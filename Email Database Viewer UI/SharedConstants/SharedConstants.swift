//
//  SharedConstants.swift
//  SharedConstants
//
//  Created by プレイヤー怜央 on 2026/01/04.
//

public enum InboxNames: String, CaseIterable, Identifiable, Hashable {
    case allEmails = "All Emails"
    case inbox = "Inbox"
    case sent = "Sent"
    case flagged = "Flagged"
    case draft = "Draft"
    case deleted = "Deleted"
    
    public var id: String { rawValue }
    
    public var systemIcon: String {
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

public struct SidebarConstants {
    public static let allEmailAccounts: String = "@all"
}
