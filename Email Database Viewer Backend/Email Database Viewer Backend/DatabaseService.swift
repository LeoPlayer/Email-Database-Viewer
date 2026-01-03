//
//  DatabaseService.swift
//  Email Database Viewer Backend
//
//  Created by プレイヤー怜央 on 2025/12/11.
//

import Foundation
import GRDB
import SharedConstants


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
                    t.primaryKey(EmailItem.CodingKeys.id.rawValue, .text)
                    t.column(EmailItem.CodingKeys.sender_name.rawValue, .text)
                    t.column(EmailItem.CodingKeys.sender_address.rawValue, .text).notNull()
                    t.column(EmailItem.CodingKeys.receiver_name.rawValue, .text)
                    t.column(EmailItem.CodingKeys.receiver_address.rawValue, .text).notNull()
                    t.column(EmailItem.CodingKeys.email_title.rawValue, .text).notNull()
                    t.column(EmailItem.CodingKeys.email_content.rawValue, .text).notNull()
                    t.column(EmailItem.CodingKeys.email_date.rawValue, .datetime).notNull()
                }
            }
            print("Successfully created table")
        } catch {
            throw DatabaseError.queryFailed("Failed to create table: \(error.localizedDescription)")
        }
    }
    
    // inserts as many items as possible. Updates if entry existing
    public func insertItems(_ items: [EmailItem]) async throws {
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
    
    public func searchItems(keyword: String, email: String) throws -> [EmailItem] {
        do {
            return try dbQueue.read { db in
                let searchPattern = "%\(keyword.lowercased())%"
                
                var request = EmailItem.all()
                
                if email != SidebarConstants.allEmailAccounts {
                    request = request.filter(
                        EmailItem.Columns.receiverAddress == email
                    )
                }
                
                request = request
                    .filter(
                        EmailItem.Columns.senderName.like(searchPattern)        ||
                        EmailItem.Columns.senderAddress.like(searchPattern)     ||
                        EmailItem.Columns.receiverName.like(searchPattern)      ||
                        EmailItem.Columns.receiverAddress.like(searchPattern)   ||
                        EmailItem.Columns.emailTitle.like(searchPattern)        ||
                        EmailItem.Columns.emailContent.like(searchPattern)
                    )
                    .order(EmailItem.Columns.id.asc)
                
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
