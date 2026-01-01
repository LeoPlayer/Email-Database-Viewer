//
//  SearchResult.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/16.
//

import SwiftUI
import Email_Database_Viewer_Backend

struct SearchResult: View {
    let results: [EmailItem]
    let dateFormatter: DateFormatter
    
    var body: some View {
        ScrollViewReader { proxy in
            GlassEffectContainer {
                List(results) { result in
                    VStack() {
                        HStack() {
                            Text(result.sender_name ?? result.sender_address)
                                .lineLimit(1)
                                .layoutPriority(.infinity)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("To: " + result.receiver_address)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        HStack() {
                            Text(result.email_title)
                                .lineLimit(1)
                                .font(.body)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(dateFormatter.string(from: result.email_date))
                                .lineLimit(1)
                                .layoutPriority(.infinity)
                                .foregroundStyle(.secondary)
                                .font(.callout)
                        }
                        
                        Text(result.email_content.replacingOccurrences(of: "\n", with: " "))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .truncationMode(.tail)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
//                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .glassEffect(in: .rect(cornerRadius: 10))
                }
                .onChange(of: results) {
                    if results.count > 0 {
                        proxy.scrollTo(results[0].id, anchor: UnitPoint.top)
                    }
                }
            }
        }
    }
}
