//
//  DatabaseService.swift
//  Email Database Viewer Backend
//
//  Created by プレイヤー怜央 on 2025/12/11.
//

import Foundation
import PostgresClientKit


public struct Item: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let description: String? // optional
}

public enum DatabaseError: Error {
    case connectionFailed(String)
    case queryExecutionFailed(String)
    case dataParsingFailed(String)
    case unknownError(String)
}

public class DatabaseService {
    private let config: ConnectionConfiguration
    
    public init () {
        var config = ConnectionConfiguration()
        config.host = Constants.databaseHost
        config.port = Constants.databasePort
        config.database = Constants.databaseName
        config.user = Constants.databaseUser
        config.credential = .cleartextPassword(password: Constants.databasePassword)
        self.config = config
    }
    
    private func getConnection() throws -> Connection {
        do {
            return try Connection(configuration: config)
        } catch {
            throw DatabaseError.connectionFailed("Failed to connect to database: \(error.localizedDescription)")
        }
    }
    
    // creates table if there is none of that name
    public func createTable() async throws {
        let connection = try getConnection()
        defer { connection.close() }
        
        let text = """
            CREATE TABLE IF NOT EXISTS temp_table {
                id          UUID PRIMARY KEY,
                name        VARCHAR(255) NOT NULL,
                description TEXT
            };
        """
        
        do {
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }
            
            try statement.execute()
            print("Table 'temp_table' created or already exists")
        } catch {
            throw DatabaseError.queryExecutionFailed("Failed to create table: \(error.localizedDescription)")
        }
    }
    
    public func insertItems(items: [Item]) async throws {
        let connection = try getConnection()
        defer { connection.close() }
        
        let text = """
            INSERT INTO items (id, name, description)
            VALUES      ($1, $2, $3);
        """
        
        for item in items {
            do {
                let statement = try connection.prepareStatement(text: text)
                defer { statement.close() }
                
                try statement.execute(parameterValues: [item.id.uuidString, item.name, item.description])
            } catch {
                if items.count == 1 {
                    throw DatabaseError.queryExecutionFailed("Failed to insert item: \(error.localizedDescription)")
                }
                print("Failed to insert item \(item.name): \(error.localizedDescription)")
                // continues running for other items
            }
        }
    }
    
    public func insertItem(item: Item) async throws {
        try await insertItems(items: [item])
    }
    
    public func searchItems(keyword: String) async throws -> [Item] {
        let connection = try getConnection()
        defer { connection.close() }
        
        let text = """
            SELECT  id, name, description
            FROM    items
            WHERE   name ILIKE $1
            OR      description ILIKE $1;
        """
        
        do {
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: ["%\(keyword)%"])
            defer { cursor.close() }
            
            var results: [Item] = []
            for row in cursor {
                let columns = try row.get().columns
                
                let idString = try columns[0].string()
                guard let id = UUID(uuidString: idString) else {
                    throw DatabaseError.dataParsingFailed("Failed to get valid UUID. Retrieved: \(idString)")
                }
                
                let name = try columns[1].string()
                let description = try columns[2].string()
                
                results.append(Item(id: id, name: name, description: description))
            }
            
            return results
        } catch {
            throw DatabaseError.queryExecutionFailed("Failed to execute search with search term '\(keyword)': \(error)")
        }
    }
}
