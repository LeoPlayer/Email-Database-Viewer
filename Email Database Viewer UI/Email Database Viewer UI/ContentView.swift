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
    
    @State private var searchBarHeight: CGFloat = 150
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
    
    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            SidebarList(
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
            searchResults = try backendAPI.searchDatabase(
                searchTerm: previousSearchText,
                email: sidebarSelection?.email ?? SidebarConstants.allEmailAccounts
            )
        } catch {
            activeError = DatabaseError(title: "Database Populate Error", message: error.localizedDescription)
        }
    }
    
    private func searchDatabase(usePreviousSearchTerm: Bool = false) {
        if curStatus == .loading {
            activeError = DatabaseError(title: "Error", message: "The Database is Still Loading")
            return
        }
        
        // REPLACE WITH CHECK IF THERE EXISTS NON-EMPTY DATABASE
//        if searchResults.count == 0 {
//            activeError = DatabaseError(title: "Error", message: "Load Database First")
//            return
//        }
        
        curStatus = .loading
        defer {
            curStatus = .loaded
        }
        
        do {
            if usePreviousSearchTerm {
                searchResults = try backendAPI.searchDatabase(
                    searchTerm: previousSearchText,
                    email: sidebarSelection?.email ?? SidebarConstants.allEmailAccounts
                )
            } else {
                searchResults = try backendAPI.searchDatabase(
                    searchTerm: searchText,
                    email: sidebarSelection?.email ?? SidebarConstants.allEmailAccounts
                )
                previousSearchText = searchText
            }
        } catch {
            activeError = DatabaseError(title: "Database Search Error", message: error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
