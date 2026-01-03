//
//  SidebarList.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2026/01/02.
//

import SwiftUI

enum InboxNames: String, CaseIterable, Identifiable, Hashable {
    case allEmails = "All Emails"
    case inbox = "Inbox"
    case sent = "Sent"
    case flagged = "Flagged"
    case draft = "Draft"
    case deleted = "Deleted"
    
    var id: String { rawValue }
    
    var systemIcon: String {
        switch self {
        case .allEmails:
            return "tray.fill"
        case .inbox:
            return "envelope.fill"
        case .sent:
            return "paperplane.fill"
        case .flagged:
            return "flag.fill"
        case .draft:
            return "pencil.and.scribble"
        case .deleted:
            return "trash.fill"
        }
    }
}

protocol sidebarItem: Hashable, Identifiable {
    var id: String { get }
    var systemIcon: String { get }
    var email: String { get }
    var inboxType: InboxNames { get }
    var title: String { get } // what is shown in the sidebar
}

// Hashable methods
extension sidebarItem {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Hashable wrapper for List selection
struct AnySidebarItem: sidebarItem, Hashable, Identifiable {
    let id: String
    let title: String
    let systemIcon: String
    let email: String
    let inboxType: InboxNames
    
    private let _getSidebarItem: () -> any sidebarItem
    
    init<Item: sidebarItem>(_ item: Item) {
        self.id = item.id
        self.title = item.title
        self.systemIcon = item.systemIcon
        self.email = item.email
        self.inboxType = item.inboxType
        self._getSidebarItem = { item }
    }
    
    var base: any sidebarItem {
        _getSidebarItem()
    }
    
    static func == (lhs: AnySidebarItem, rhs: AnySidebarItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

private struct inboxType: sidebarItem {
    let inboxType: InboxNames
    let parent: account
    var email: String { parent.email }
    var id: String { email + "/" + inboxType.rawValue }
    var title: String { inboxType.rawValue.capitalized }
    var systemIcon: String { inboxType.systemIcon }
}

private struct account: sidebarItem {
    let email: String
    let systemIcon: String = "person.crop.circle.fill"
    var id: String { email }
    var title: String { email }
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
                    }
                }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

// temporary data
private var allSidebarAccounts: [account] {
    return [
        account(email: "test@gmail.com")
    ]
}

private var allSidebarInboxes: [inboxType] {
    return [
        inboxType(inboxType: .allEmails, parent: allSidebarAccounts[0]),
        inboxType(inboxType: .inbox, parent: allSidebarAccounts[0]),
        inboxType(inboxType: .sent, parent: allSidebarAccounts[0]),
        inboxType(inboxType: .flagged, parent: allSidebarAccounts[0]),
        inboxType(inboxType: .draft, parent: allSidebarAccounts[0]),
        inboxType(inboxType: .deleted, parent: allSidebarAccounts[0])
    ]
}

struct SidebarList: View {
    @Binding var selection: AnySidebarItem?
    @Binding var expandedStates: [String: Bool]
    
    var body: some View {
        List(selection: $selection) {
            ForEach(allSidebarAccounts) { account in
                DisclosureGroup(isExpanded: Binding(
                    get: { expandedStates[account.id, default: true] },
                    set: { expandedStates[account.id] = $0}
                )) {
                    ForEach(allSidebarInboxes) { inboxItem in
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
        .onChange(of: selection) { oldValue, newValue in
            guard let newBase = newValue?.base else {
                print("sidebarSelection: nil")
                return
            }
            
            if let oldBase = oldValue?.base {
                if oldBase.email == newBase.email && oldBase.inboxType.rawValue == newBase.inboxType.rawValue {
                    return
                }
            }
            
            print("sidebarSelection: email=\"\(newBase.email)\", inboxType=\"\(newBase.inboxType.rawValue.capitalized)\"")
        }
    }
}
