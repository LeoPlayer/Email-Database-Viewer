//
//  ContentView.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/10.
//

import SwiftUI
import Email_Database_Viewer_Backend

struct ContentView: View {
    @State private var curStatus: Status = .loaded
    @State private var searchText: String = ""
    @State private var previousSearchText = ""
    @State private var searchResults: [EmailItem] = []
    @State private var activeError: DatabaseError? = nil
        
    private let backendAPI = BackendAPI()
    private let userDateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Oceania/Sydney")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            // sidebar
            List {
                Button {
                    print("temp sidebar button pressed")
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.body)
                        Text("Temp Button")
                            .font(.body)
                    }
                    .padding(5)
                }
                .buttonStyle(.automatic)
            }
            .listStyle(.sidebar)
            .frame(minWidth: 155)
            .toolbar {
                ToolbarItem() {
                    Button {
                        print("plus button pressed")
                        Task {
                            await addDataToDatabase()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
            // main view
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
                    ScrollViewReader { proxy in
                        GlassEffectContainer {
                            List(searchResults) { result in
                                SearchResult(result: result, dateFormatter: userDateFormatter)
                            }
                            .onChange(of: searchResults) {
                                if searchResults.count > 0 {
                                    proxy.scrollTo(searchResults[0].id, anchor: UnitPoint.top)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Email Database Viewer")
        }
        .alert(item: $activeError) { error in
            Alert(
                title: Text(error.title),
                message: Text(error.message),
                dismissButton: .default(Text("OK")) {}
            )
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
