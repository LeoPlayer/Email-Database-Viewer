//
//  DatabaseService.swift
//  Email Database Viewer Backend
//
//  Created by プレイヤー怜央 on 2025/12/11.
//

import Foundation
import GRDB


public class DatabaseService {
    private let dbQueue: DatabaseQueue
    
    public init () throws {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DatabaseError.unknownError("Could not find document directory (App Support)")
        }
        
        let databasePath = documentsDirectory.appendingPathComponent(DatabaseConstants.databaseFileName)
        
        do {
            self.dbQueue = try DatabaseQueue(path: databasePath.path)
            print("Connected to SQLite database \(databasePath.path) successfully")
        } catch {
            throw DatabaseError.connectionFailed("path name = \(databasePath.path), error message: \(error.localizedDescription)")
        }
    }
    
    // creates table, continues if one of the same already exists
    public func createTable() async throws {
        do {
            try await dbQueue.write {db in
                try db.create(table: DatabaseConstants.databaseTableName, ifNotExists: true) { t in
                    t.primaryKey(Item.Columns.id.name, .text)
                    t.column(Item.Columns.name.name, .text).notNull()
                    t.column(Item.Columns.description.name, .text)
                }
            }
            print("Successfully created table")
        } catch {
            throw DatabaseError.queryFailed("Failed to create table: \(error.localizedDescription)")
        }
    }
    
    // inserts as many items as possible. Updates if entry existing
    public func insertItems(_ items: [Item]) async throws {
        do {
            let num_failed = try await dbQueue.write { db -> Int in
                var num_failed = 0
                for item in items {
                    do {
                        try item.save(db)
                    } catch {
                        print("Failed to insert \(item): \(error.localizedDescription)")
                        num_failed += 1
                    }
                }
                return num_failed
            }
            
            if num_failed > 0 {
                throw DatabaseError.queryFailed("Could not insert all items. \(items.count - num_failed) succeeded, " +
                                                "\(num_failed) failed")
            }
            
            print("\(items.count) entries added/updated (includes rows with no changes)")
        } catch {
            throw DatabaseError.unknownError("Occurred in insertItems(): \(error.localizedDescription)")
        }
    }
    
    public func searchItems(_ keyword: String) throws -> [Item] {
        do {
            return try dbQueue.read { db in
                let searchPattern = "%\(keyword.lowercased())%"
                
                let request = Item.all()
                    .filter {
                        $0.name.collating(.caseInsensitiveCompare).like(searchPattern) ||
                        $0.description.collating(.caseInsensitiveCompare).like(searchPattern)
                    }
                    .order(Item.Columns.id.asc)
                
                do {
                    return try request.fetchAll(db)
                } catch {
                    throw DatabaseError.queryFailed("Failed to search with keyword '\(keyword)': \(error.localizedDescription)")
                }
            }
        } catch {
            throw DatabaseError.unknownError("Occurred in searchItems(): \(error.localizedDescription)")
        }
    }
    
    
//    
//    public func searchItems(_ keyword: String) async throws -> [Item] {
//        let connection = try getConnection()
//        defer { connection.close() }
//        
//        let text = """
//            SELECT  id, name, description
//            FROM    items
//            WHERE   name ILIKE $1
//            OR      description ILIKE $1;
//        """
//        
//        do {
//            let statement = try connection.prepareStatement(text: text)
//            defer { statement.close() }
//            
//            let cursor = try statement.execute(parameterValues: ["%\(keyword)%"])
//            defer { cursor.close() }
//            
//            var results: [Item] = []
//            for row in cursor {
//                let columns = try row.get().columns
//                
//                let idString = try columns[0].string()
//                guard let id = UUID(uuidString: idString) else {
//                    throw DatabaseError.dataParsingFailed("Failed to get valid UUID. Retrieved: \(idString)")
//                }
//                
//                let name = try columns[1].string()
//                let description = try columns[2].string()
//                
//                results.append(Item(id: id, name: name, description: description))
//            }
//            
//            return results
//        } catch {
//            throw DatabaseError.queryExecutionFailed("Failed to execute search with search term '\(keyword)': \(error)")
//        }
//    }
}

// singleton wrapper
public extension DatabaseService {
    static let instance: DatabaseService = {
        do {
            return try DatabaseService()
        } catch {
            fatalError("Failed to initialize DatabaseService: \(error.localizedDescription)")
        }
    }()
}
