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

public struct Item: Codable, Identifiable, Equatable, FetchableRecord, PersistableRecord, TableRecord {
    public let id: String
    public let name: String
    public let description: String? // optional
    
    public static let databaseTableName = DatabaseConstants.databaseTableName
    
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let description = Column(CodingKeys.description)
    }
    
    public init(id: String, name: String, description: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
    }
    
    public init (row: Row) throws {
        self.id = try row.decode(String.self, forColumn: Columns.id)
        self.name = try row.decode(String.self, forColumn: Columns.name)
        self.description = try? row.decode(String.self, forColumn: Columns.description)
    }
    
    public static func == (lhs: Item, rhs: Item) -> Bool {
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
