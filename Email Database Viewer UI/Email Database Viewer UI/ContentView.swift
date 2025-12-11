//
//  ContentView.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/10.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [String] = []
    @State private var message: String = ""
    
    var body: some View {
        NavigationView {
            // sidebar
            List {
                Button {
                    print("temp sidebar button pressed")
                } label: {
                    Label("Temp Button", systemImage: "exclamationmark.triangle")
                }
                .buttonStyle(.automatic)
            }
            .listStyle(.sidebar)
            .frame(minWidth: 150)
            .toolbar {
                ToolbarItem() {
                    Button {
                        print("plus button pressed")
                        self.message = "loading JSON"
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
            // main view
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Search Database")
                        .font(.title2)
                        .bold()
                    
                    TextField("Insert Search Term", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Spacer()
                        Button {
                            self.message = "Search for \"\(searchText)\""
                            self.searchResults = ["temp result 1", "temp result 2", "temp result 3"]
                        } label: {
                            Label("Search", systemImage: "magnifyingglass")
                                .font(.headline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                    
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
                if !searchResults.isEmpty {
                    List(searchResults, id: \.self) { result in
                        VStack() {
                            Text(result)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.init(nsColor: .windowBackgroundColor))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 0.5)
                                )
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                } else {
                    //Spacer()
                    Text(message.isEmpty ? "load a JSON file to start" : message)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Email Database Viewer")
        }
    }
}

#Preview {
    ContentView()
}
