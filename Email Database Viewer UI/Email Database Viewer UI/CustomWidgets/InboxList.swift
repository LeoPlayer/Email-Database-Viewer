//
//  InboxList.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/17.
//


import SwiftUI

private struct myInboxRow: Identifiable {
    let id: UUID
    let title: String
    let action: () -> Void
}

struct InboxList: View {
    let emailAddress: String
//    let searchFunction: (String) -> Void
    
    @State private var isExpanded: Bool = false
    
    private let subItems: [myInboxRow] = [
        myInboxRow(id: UUID(), title: "All Emails", action: {print("clicked all emails")}),
        myInboxRow(id: UUID(), title: "Inbox", action: {print("clicked inbox")}),
        myInboxRow(id: UUID(), title: "Sent", action: {print("clicked sent")}),
        myInboxRow(id: UUID(), title: "Flagged", action: {print("clicked flagged")}),
        myInboxRow(id: UUID(), title: "Draft", action: {print("clicked draft")}),
        myInboxRow(id: UUID(), title: "Deleted", action: {print("clicked deleted")})
    ]
    
    var body: some View {
//        DisclosureGroup(
//            isExpanded: $isExpanded,
//            content: {
//                GlassEffectContainer (
//                    content: {
//                        ForEach(subItems) { item in
//                            Button(action: item.action) {
//                                Text(item.title)
//                                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
//                                    .padding(.vertical, 8)
//                            }
//                            .background(Color.clear)
//                            .glassEffect()
//                        }
//                    }
//                )
//            },
//            label: {
//                Text(emailAddress)
//                    .font(.headline)
//                    .foregroundStyle(Color.accentColor)
//            }
//        )
        
        
        
        
//        ScrollViewReader { proxy in
//            GlassEffectContainer {
//                List(subItems) { item in
//                    VStack() {
//                        HStack() {
//                            Text(item.title)
//                                .lineLimit(1)
//                                .font(.body)
//                                .foregroundStyle(.primary)
//                            Spacer()
//                            Text(item.title)
//                                .lineLimit(1)
//                                .layoutPriority(.infinity)
//                                .foregroundStyle(.secondary)
//                                .font(.callout)
//                        }
//                        
//                        Text(item.title + " lmao lmao lmao")
//                        .lineLimit(1)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .truncationMode(.tail)
//                        .font(.callout)
//                        .foregroundStyle(.secondary)
//                    }
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 8)
//                    .listRowSeparator(.hidden)
//                    .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
//                    .glassEffect(in: .rect(cornerRadius: 10))
//                }
//            }
//        }
        
        List(subItems) { item in
            Text(item.title)
        }
    }
}
