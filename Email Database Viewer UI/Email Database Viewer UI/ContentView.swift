//
//  ContentView.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/10.
//

import SwiftUI
import Email_Database_Viewer_Backend
import SharedConstants

struct ContentView: View {
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .all // shows sidebar by default
    
    @State private var sidebarSelection: AnySidebarItem?
    @State private var sidebarExpandedStates: [String: Bool] = [:] // per email address
    @State private var accounts: [(email: String, systemIcon: String)] = []
    
    @State private var searchBarHeight: CGFloat = 150
    @State private var curStatus: Status = .loading // stores whether there is an ongoing update to the database
    @State private var searchText: String = ""
    @State private var previousSearchText = "" // to determine behaviour when searching the database fails
    @State private var searchResults: [EmailItem] = []
    @State private var activeAlert: AlertInfo? // shows alert when not nil
        
    @State private var backendAPI: BackendAPI?
    
    private let userDateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Oceania/Sydney")
        return formatter
    }()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            SidebarList(
                accounts: $accounts,
                selection: $sidebarSelection,
                expandedStates: $sidebarExpandedStates,
                searchDatabasePrevTerm: { searchDatabase(usePreviousSearchTerm: true) }
            )
        } content: {
            ZStack(alignment: .top) {
                VStack {
                    if curStatus == .loading {
                        Spacer()
                        Text("Loading Data...").foregroundStyle(.gray)
                            .padding(.top, searchBarHeight + 20)
                        Spacer()
                    } else if searchResults.count == 0 {
                        Spacer()
                        Text("No Emails").foregroundStyle(.gray)
                            .padding(.top, searchBarHeight + 20)
                        Spacer()
                    } else {
                        SearchResult(results: searchResults, dateFormatter: userDateFormatter, searchBarHeight: searchBarHeight)
                    }
                }
                
                VStack {
                    SearchBar(
                        searchText: $searchText,
                        searchBarHeight: $searchBarHeight,
                        searchDatabaseFunc: { searchDatabase(usePreviousSearchTerm: false) }
                    )
                    
                    Spacer()
                }
            }
        } detail: {
            // TEMP
            Text("No Email Selected")
                .font(.title)
                .foregroundStyle(.tertiary)
        }
        .alert(item: $activeAlert) { errorInfo in
            AlertFactory.buildAlert(for: errorInfo)
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
        .onAppear() {
            Task {
                await initialiseDatabase()
            }
        }
    }
    
    // ONLY ONE OF BELOW FUNCTIONS TO RUN AT ONCE
    // THIS IS SO ONLY ONE ERROR IS THROWN AT A TIME
    private func initialiseDatabase() async {
        curStatus = .loading
        defer {
            curStatus = .loaded
        }
        
        do {
            try backendAPI = BackendAPI()
        } catch {
            activeAlert = .fatalError(errorType: "Failed To Initialise Backend API", message: error.localizedDescription)
            return
        }
        
        var requireMigration: Bool = false
        
        do {
            requireMigration = try backendAPI!.requiresMigration()
        } catch {
            activeAlert = .fatalError(errorType: "Require Migration Check Error", message: error.localizedDescription)
            return
        }
        
        if requireMigration {
            activeAlert = .requireMigration(details: "")
            
            while activeAlert != nil {
                try? await Task.sleep(nanoseconds: 200_000_000)
            }
            
            do {
                try backendAPI!.applyMigration()
            } catch {
                activeAlert = .fatalError(errorType: "Failed to Migrate", message: "Failed migration step reverted: " + error.localizedDescription)
                return
            }
        }
        
        do {
            accounts = try backendAPI!.getAllEmails().map{ e in (email: e, systemIcon: "person.crop.circle.fill") }
        } catch {
            activeAlert = .error(title: "Email Load Error", message: error.localizedDescription)
        }
        
        do {
            searchResults = try backendAPI!.searchDatabase(
                searchTerm: "",
                email: sidebarSelection?.email ?? SidebarConstants.allEmailAccounts
            )
        } catch {
            activeAlert = .error(title: "Database Load Error", message: error.localizedDescription)
            return
        }
    }
    
    private func addDataToDatabase() async {
        if curStatus == .loading {
            activeAlert = .error(title: "Error", message: "The Database is Still Loading")
            return
        }
        
        curStatus = .loading
        defer {
            curStatus = .loaded
        }
        
        do {
            try await backendAPI!.populate()
            accounts = try backendAPI!.getAllEmails().map{ e in (email: e, systemIcon: "person.crop.circle.fill") } // TEMP
            searchResults = try backendAPI!.searchDatabase(
                searchTerm: previousSearchText,
                email: sidebarSelection?.email ?? SidebarConstants.allEmailAccounts
            )
        } catch {
            activeAlert = .error(title: "Database Populate Error", message: error.localizedDescription)
            return
        }
    }
    
    // usePreviousSearchTerm = true if the result should be a modification of the showing result
    private func searchDatabase(usePreviousSearchTerm: Bool = false) {
        if curStatus == .loading {
            activeAlert = .error(title: "Error", message: "The Database is Still Loading")
            return
        }
        
        curStatus = .loading
        defer {
            curStatus = .loaded
        }
        
        do {
            if usePreviousSearchTerm {
                searchResults = try backendAPI!.searchDatabase(
                    searchTerm: previousSearchText,
                    email: sidebarSelection?.email ?? SidebarConstants.allEmailAccounts
                )
            } else {
                searchResults = try backendAPI!.searchDatabase(
                    searchTerm: searchText,
                    email: sidebarSelection?.email ?? SidebarConstants.allEmailAccounts
                )
                previousSearchText = searchText
            }
        } catch {
            activeAlert = .error(title: "Database Search Error", message: error.localizedDescription)
            return
        }
    }
}

#Preview {
    ContentView()
}
