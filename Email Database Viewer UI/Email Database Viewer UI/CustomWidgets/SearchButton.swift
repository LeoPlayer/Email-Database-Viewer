//
//  SearchButton.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/16.
//

import SwiftUI

struct SearchButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Search", systemImage: "magnifyingglass")
                .font(.headline)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
        .foregroundColor(.white)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.accentColor)
        }
    }
}
