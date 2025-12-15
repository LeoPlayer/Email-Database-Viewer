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
    @State private var searchResults: [Item] = []
    @State private var activeError: DatabaseError? = nil
        
    private let backendAPI = BackendAPI()
    
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
                        Button {
                            searchDatabase()
                        } label: {
                            Label("Search", systemImage: "magnifyingglass")
                                .font(.headline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                        }
                        .buttonStyle(.plain)
                        .background {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.accentColor)
                        }
                        .foregroundColor(.white)
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
                        List(searchResults) { result in
                            VStack() {
                                Text(result.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if (result.description != nil) {
                                    Text(result.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.init(nsColor: .windowBackgroundColor))
                                    .stroke(Color.secondary, lineWidth: 0.5)
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                        .onChange(of: searchResults) {
                            if searchResults.count > 0 {
                                proxy.scrollTo(searchResults[0].id, anchor: UnitPoint.top)
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
