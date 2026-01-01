//
//  ContentView.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/10.
//

import SwiftUI
import Email_Database_Viewer_Backend

// TEMP

enum InboxNames: String, CaseIterable, Identifiable, Hashable {
    case allEmails = "All Emails"
    case inbox = "Inbox"
    case sent = "Sent"
    case flagged = "Flagged"
    case draft = "Draft"
    case deleted = "Deleted"
    
    var id: String { rawValue }
    
    var systemIcon: String {
        switch self {
        case .allEmails:
            return "tray.fill"
        case .inbox:
            return "envelope.fill"
        case .sent:
            return "paperplane.fill"
        case .flagged:
            return "flag.fill"
        case .draft:
            return "pencil.and.scribble"
        case .deleted:
            return "trash.fill"
        }
    }
}

protocol sidebarItem: Hashable, Identifiable {
    var id: String { get }
    var title: String { get }
    var systemIcon: String { get }
    var inboxType: InboxNames { get }
}

extension sidebarItem {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// END TEMP

struct ContentView: View {
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .all // shows sidebar by default
    
    @State private var curStatus: Status = .loaded // stores whether there is an ongoing update to the database
    @State private var searchText: String = ""
    @State private var previousSearchText = "" // to determine behaviour when searching the database fails
    @State private var searchResults: [EmailItem] = []
    @State private var activeError: DatabaseError? // shows alert when not nil
        
    private let backendAPI = BackendAPI()
    private let userDateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Oceania/Sydney")
        return formatter
    }()
    
    
    // TEMP
    
    struct inboxType: sidebarItem {
        let inboxType: InboxNames
        let parent: account
        var title: String { inboxType.rawValue }
        var systemIcon: String { inboxType.systemIcon }
        var id: String { parent.title + "." + title }
    }
    
    struct account: sidebarItem {
        var inboxType: InboxNames { .allEmails }
        let title: String
        let systemIcon: String = "person.crop.circle.fill"
        var id: String {title}
    }
    
    @State private var sidebarSelection: AnyHashable?
    @State private var expandedStates: [String: Bool] = [:]
    
    private var allSidebarAccounts: [account] {
        return [
            account(title: "test@gmail.com")
        ]
    }
    
    private var allSidebarInboxes: [inboxType] {
        return [
            inboxType(inboxType: .allEmails, parent: allSidebarAccounts[0]),
            inboxType(inboxType: .inbox, parent: allSidebarAccounts[0]),
            inboxType(inboxType: .sent, parent: allSidebarAccounts[0]),
            inboxType(inboxType: .flagged, parent: allSidebarAccounts[0]),
            inboxType(inboxType: .draft, parent: allSidebarAccounts[0]),
            inboxType(inboxType: .deleted, parent: allSidebarAccounts[0])
        ]
    }
    
    // END TEMP
    
    struct InboxTypeView: View {
        let inboxType: inboxType
        
        var body: some View {
            HStack {
                Image(systemName: inboxType.systemIcon)
                    .foregroundStyle(.secondary)
                Text(inboxType.title)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
            .tag(inboxType)
        }
    }
    
    struct AccountView: View {
        let account: account
        @Binding var expanded: Bool
        @Binding var sidebarSelection: AnyHashable?
        
        var body: some View {
            Button(action: {
                expanded.toggle()
                sidebarSelection = account
            }) {
                HStack {
                    Image(systemName: account.systemIcon)
                        .foregroundStyle(sidebarSelection  == AnyHashable(account) ? Color.accentColor : .secondary)
                    Text(account.title)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .tag(account)
        }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            // sidebar
            List(selection: $sidebarSelection) {
                ForEach(allSidebarAccounts) { account in
                    DisclosureGroup(isExpanded: Binding(
                        get: { expandedStates[account.id, default: true] },
                        set: { expandedStates[account.id] = $0}
                    )) {
                        ForEach(allSidebarInboxes) { inboxItem in
                            InboxTypeView(inboxType: inboxItem)
                        }
                    } label: {
                        AccountView(account: account, expanded: Binding(
                            get: { expandedStates[account.id, default: true] },
                            set: { expandedStates[account.id] = $0}
                        ), sidebarSelection: $sidebarSelection)
                    }
                }
            }
            .listStyle(.sidebar)
            .frame(minWidth: 155)
        } content: {
            VStack {
                VStack(alignment: .leading) {
                    Text("Search Database")
                        .font(.title2)
                        .bold()
                    
                    TextField("Insert Search Term", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            searchDatabase()
                        }
                    
                    HStack {
                        Spacer()
                        SearchButton {
                            searchDatabase()
                        }
                    }
                    
                }
                .padding()
                .background {
                    ContainerRelativeShape()
                        .fill(.thinMaterial)
                }
                .cornerRadius(15)
                
                if curStatus == .loading {
                    Text("Loading Data...").foregroundStyle(.gray)
                } else if searchResults.count == 0 {
                    Text("Load JSON to start").foregroundStyle(.gray)
                }
                
                if !searchResults.isEmpty {
                    SearchResult(results: searchResults, dateFormatter: userDateFormatter)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Email Database Viewer")
        } detail: {
            Text("No Email Selected")
                .font(.title)
                .foregroundStyle(.tertiary)
        }
        .alert(item: $activeError) { error in
            Alert(
                title: Text(error.title),
                message: Text(error.message),
                dismissButton: .default(Text("OK")) {}
            )
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button ("Add Database File", systemImage: "plus") {
                    print("plus button pressed")
                    Task {
                        await addDataToDatabase()
                    }
                }
            }
        }
    }
    
    private func addDataToDatabase() async {
        if curStatus == .loading {
            activeError = DatabaseError(title: "Error", message: "The Database is Still Loading")
            return
        }
        
        curStatus = .loading
        defer {
            curStatus = .loaded
        }
        
        do {
            try await backendAPI.populate()
            searchResults = try backendAPI.searchDatabase(previousSearchText)
        } catch {
            activeError = DatabaseError(title: "Database Populate Error", message: error.localizedDescription)
        }
    }
    
    private func searchDatabase() {
        if curStatus == .loading {
            activeError = DatabaseError(title: "Error", message: "The Database is Still Loading")
            return
        }
        
        if searchResults.count == 0 {
            activeError = DatabaseError(title: "Error", message: "Load Database First")
            return
        }
        
        curStatus = .loading
        defer {
            curStatus = .loaded
        }
        
        do {
            searchResults = try backendAPI.searchDatabase(searchText)
            previousSearchText = searchText
        } catch {
            activeError = DatabaseError(title: "Database Search Error", message: error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
