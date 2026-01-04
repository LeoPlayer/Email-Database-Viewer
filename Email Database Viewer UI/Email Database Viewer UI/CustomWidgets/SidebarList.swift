//
//  SidebarList.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2026/01/02.
//

import SwiftUI
import SharedConstants

private struct inboxItem: sidebarItem {
    let inboxType: InboxNames
    let parent: accountItem
    var email: String { parent.email }
    var id: String { email + "/" + inboxType.rawValue }
    var title: String { inboxType.rawValue.capitalized }
    var systemIcon: String { inboxType.systemIcon }
}

private struct accountItem: sidebarItem {
    let email: String
    let systemIcon: String
    var id: String { email }
    var title: String { email == SidebarConstants.allEmailAccounts ? "All Accounts" : email } // special case for default all accounts tab
    var inboxType: InboxNames { .allEmails }
}

private struct IconAndText: View {
    let image: Image
    let sizedText: Text
    @State private var iconWidth: CGFloat = 0
    
    var body: some View {
        HStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: iconWidth, height: iconWidth)
                .frame(minWidth: iconWidth + 4, alignment: .leading)
                .foregroundStyle(.secondary)
            
            sizedText
                .background {
                    GeometryReader { proxy in
                        Spacer()
                            .frame(height: 0)
                            .onAppear {
                                iconWidth = proxy.size.height
                            }
                            .onChange(of: proxy.size.height) {
                                iconWidth = proxy.size.height
                            }
                    }
                }
        }
        .contentShape(Rectangle())
    }
}

//// temporary data
//private var allAccountArray: [accountItem] {
//    return [
//        accountItem(email: SidebarConstants.allEmailAccounts, systemIcon: "tray.2.fill"),
//        accountItem(email: "leo1@gmail.com", systemIcon: "person.crop.circle.fill"),
//        accountItem(email: "leo2@outlook.com", systemIcon: "person.crop.circle.fill")
//    ]
//}

private var allInboxTypes: [InboxNames] = [
    .allEmails, .inbox, .sent, .flagged, .draft, .deleted
]

struct SidebarList: View {
    @Binding var accounts: [(email: String, systemIcon: String)]
    @Binding var selection: AnySidebarItem?
    @Binding var expandedStates: [String: Bool]
    var searchDatabasePrevTerm: () -> Void
    
    @State private var allAccountArray: [accountItem] = [accountItem(email: SidebarConstants.allEmailAccounts, systemIcon: "tray.2.fill")]
        
    var body: some View {
        List(selection: $selection) {
            ForEach(allAccountArray) { account in
                DisclosureGroup(isExpanded: Binding(
                    get: { expandedStates[account.id, default: true] },
                    set: { expandedStates[account.id] = $0}
                )) {
                    ForEach(allInboxTypes) { inboxType in
                        let inboxItem = inboxItem(inboxType: inboxType, parent: account)
                        IconAndText(image: Image(systemName: inboxItem.systemIcon), sizedText: Text(inboxItem.title))
                            .tag(AnySidebarItem(inboxItem))
                    }
                } label: {
                    IconAndText(image: Image(systemName: account.systemIcon), sizedText: Text(account.title))
                        .padding(.leading, 4)
                        .tag(AnySidebarItem(account))
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 155)
        .onAppear {
            selection = AnySidebarItem(allAccountArray[0])
        }
        .onChange(of: selection) { oldValue, newValue in
            guard let newBase = newValue?.base else {
                print("sidebarSelection: nil")
                return
            }
            
            if let oldBase = oldValue?.base {
                if oldBase.email == newBase.email && oldBase.inboxType.rawValue == newBase.inboxType.rawValue {
                    return
                }
            } else {
                return // if oldbase == nil
            }
            
            searchDatabasePrevTerm()
        }
        .onChange(of: accounts.isEmpty) {
            if accounts.isEmpty == false {
                let allEmails = allAccountArray.map { a in a.email }
                
                for account in accounts {
                    if allEmails.contains(account.email) {
                        continue
                    }
                    allAccountArray.append(accountItem(email: account.email, systemIcon: account.systemIcon))
                }
                
                accounts = []
            }
        }
    }
}
