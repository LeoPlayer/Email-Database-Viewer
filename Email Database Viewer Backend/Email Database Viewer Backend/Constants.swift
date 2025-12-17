//
//  Constants.swift
//  Email Database Viewer Backend
//
//  Created by プレイヤー怜央 on 2025/12/11.
//

import Foundation
import GRDB


public struct DatabaseConstants {
    static let databaseFileName = "my_database.sqlite"
    static let databaseTableName = "temp_table_name"
}

public struct EmailItem: Codable, Identifiable, Equatable, FetchableRecord, PersistableRecord, TableRecord {
    public let id: String
    public let sender_name: String?
    public let sender_address: String
    public let receiver_name: String?
    public let receiver_address: String
    public let email_title: String
    public let email_content: String
    public let email_date: Date
    
    public static let databaseTableName = DatabaseConstants.databaseTableName
    
    public enum CodingKeys: String, CodingKey {
            case id
            case sender_name
            case sender_address
            case receiver_name
            case receiver_address
            case email_title
            case email_content
            case email_date
        }
    
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let senderName = Column(CodingKeys.sender_name)
        static let senderAddress = Column(CodingKeys.sender_address)
        static let receiverName = Column(CodingKeys.receiver_name)
        static let receiverAddress = Column(CodingKeys.receiver_address)
        static let emailTitle = Column(CodingKeys.email_title)
        static let emailContent = Column(CodingKeys.email_content)
        static let emailDate = Column(CodingKeys.email_date)
    }
    
    public init(
        id: String,
        senderName: String? = nil,
        senderAddress: String,
        receiverName: String? = nil,
        receiverAddress: String,
        emailTitle: String,
        emailContent: String,
        emailDate: Date
    ) {
        self.id = id
        self.sender_name = senderName
        self.sender_address = senderAddress
        self.receiver_name = receiverName
        self.receiver_address = receiverAddress
        self.email_title = emailTitle
        self.email_content = emailContent
        self.email_date = emailDate
    }
    
    public init (row: Row) throws {
        self.id = try row.decode(String.self, forColumn: Columns.id)
        self.sender_name = try? row.decode(String.self, forColumn: Columns.senderName)
        self.sender_address = try row.decode(String.self, forColumn: Columns.senderAddress)
        self.receiver_name = try? row.decode(String.self, forColumn: Columns.receiverName)
        self.receiver_address = try row.decode(String.self, forColumn: Columns.receiverAddress)
        self.email_title = try row.decode(String.self, forColumn: Columns.emailTitle)
        self.email_content = try row.decode(String.self, forColumn: Columns.emailContent)
        self.email_date = try row.decode(Date.self, forColumn: Columns.emailDate)
    }
    
    public static func == (lhs: EmailItem, rhs: EmailItem) -> Bool {
        lhs.id == rhs.id
    }
}

public enum DatabaseError: Error, LocalizedError {
    case connectionFailed(String)
    case queryFailed(String)
    case dataParsingFailed(String)
    case unknownError(String)
    
    // localised message
    public var errorDescription: String? {
        switch self {
        case .connectionFailed(let string):
            return "Failed to connect to database: \(string)"
        case .queryFailed(let string):
            return "Failed to run query: \(string)"
        case .dataParsingFailed(let string):
            return "Failed to parse data: \(string)"
        case .unknownError(let string):
            return "An unknown error occurred: \(string)"
        }
    }
}
