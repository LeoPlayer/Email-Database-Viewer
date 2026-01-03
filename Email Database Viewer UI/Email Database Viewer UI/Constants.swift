//
//  Constants.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/12.
//

import Foundation
import SharedConstants

enum Status {
    case loading
    case loaded
}

struct DatabaseError: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

protocol sidebarItem: Hashable, Identifiable {
    var id: String { get } // for use by SidebarList
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

// Hashable wrapper for SidebarList List selection
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
