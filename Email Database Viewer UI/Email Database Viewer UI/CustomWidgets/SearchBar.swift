//
//  SearchBar.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2026/01/03.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var searchDatabase: () -> Void
    
    
    var body: some View {
//        GlassEffectContainer {
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
            .glassEffect(in: .rect(cornerRadius: 15))
//        }
    }
}
