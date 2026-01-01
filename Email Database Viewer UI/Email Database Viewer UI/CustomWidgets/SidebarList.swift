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

// common protocol for sidebar items
// declares required items to be shown
protocol sidebarItem: Hashable, Identifiable {
    var id: String { get }
    var title: String { get }
    var systemIcon: String { get }
    var inboxType: InboxNames { get }
}

extension sidebarItem {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct inboxType: sidebarItem {
    let inboxType: InboxNames
    let parent: account
    var title: String { inboxType.rawValue }
    var systemIcon: String { inboxType.systemIcon }
    var id: String { parent.title + "." + title }
}

struct account: sidebarItem {
    var inboxType: InboxNames { .allEmails }
    let title: String
    let systemIcon: String = "person.crop.circle.fill"
    var id: String {title}
}

struct InboxTypeView: View {
    let inboxType: inboxType
    
    var body: some View {
        HStack {
            Image(systemName: inboxType.systemIcon)
                .foregroundStyle(.secondary)
            Text(inboxType.title)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .tag(inboxType)
    }
}

struct AccountView: View {
    let account: account
    @Binding var expanded: Bool
    @Binding var sidebarSelection: AnyHashable?
    
    var body: some View {
        Button(action: {
            expanded.toggle()
            sidebarSelection = account
        }) {
            HStack {
                Image(systemName: account.systemIcon)
                    .foregroundStyle(sidebarSelection  == AnyHashable(account) ? Color.accentColor : .secondary)
                Text(account.title)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .tag(account)
    }
}

// temporary data
private var allSidebarAccounts: [account] {
    return [
        account(title: "test@gmail.com")
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
    @Binding var selection: AnyHashable?
    @Binding var expandedStates: [String: Bool]
    
    var body: some View {
        List(selection: $selection) {
            ForEach(allSidebarAccounts) { account in
                DisclosureGroup(isExpanded: Binding(
                    get: { expandedStates[account.id, default: true] },
                    set: { expandedStates[account.id] = $0}
                )) {
                    ForEach(allSidebarInboxes) { inboxItem in
                        InboxTypeView(inboxType: inboxItem)
                    }
                } label: {
                    AccountView(account: account, expanded: Binding(
                        get: { expandedStates[account.id, default: true] },
                        set: { expandedStates[account.id] = $0}
                    ), sidebarSelection: $selection)
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 155)
        
        
    }
}
