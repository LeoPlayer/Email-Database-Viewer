//
//  SearchBar.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2026/01/03.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var searchBarHeight: CGFloat
    var searchDatabaseFunc: () -> Void
    
    
    var body: some View {
        GlassEffectContainer {
            VStack(alignment: .leading) {
                Text("Search Database")
                    .font(.title2)
                    .bold()
                
                TextField("Insert Search Term", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit { // on enter button pressed
                        searchDatabaseFunc()
                    }
                
                HStack {
                    Spacer()
                    SearchButton {
                        searchDatabaseFunc()
                    }
                }
                
            }
            .padding() // around elements
            .background {
                GeometryReader { proxy in
                    Spacer()
                        .frame(height: 0)
                        .onAppear {
                            searchBarHeight = proxy.size.height
                        }
                }
            }
            .glassEffect(in: .rect(cornerRadius: 15))
            .padding() // around box
        }
    }
}
