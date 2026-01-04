//
//  DatabaseService.swift
//  Email Database Viewer Backend
//
//  Created by プレイヤー怜央 on 2025/12/11.
//

import Foundation
import GRDB
import SharedConstants


class DatabaseService {
    private let dbManager: DatabaseManager
    private let dbQueue: DatabaseQueue
    
    init () throws {    
        self.dbManager = try DatabaseManager()
        self.dbQueue = dbManager.getDbQueue()
    }
    
    func requiresMigration() throws -> Bool {
        return try dbManager.requiresMigration()
    }
    
    func applyMigration() throws {
        try dbManager.applyMigration()
    }
    
    func getAllEmails() throws -> [String] {
        do {
            return try dbQueue.read { db in
                let request = EmailItem
                    .all()
                    .select(EmailItem.Columns.receiverAddress)
                    .distinct()
                
                do {
                    return try String.fetchAll(db, request)
                } catch {
                    throw BackendError.queryFailed("Failed to get emails: \(error.localizedDescription)")
                }
            }
        } catch {
            throw BackendError.unknownError("Occurred in searchItems(): \(error.localizedDescription)")
        }
    }
    
    // inserts as many items as possible. Updates if entry existing
    func insertItems(_ items: [EmailItem]) async throws {
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
                throw BackendError.queryFailed("Could not insert all items. \(items.count - num_failed) succeeded, " +
                                                "\(num_failed) failed")
            }
            
            print("\(items.count) entries added/updated (includes rows with no changes)")
        } catch {
            throw BackendError.unknownError("Occurred in insertItems(): \(error.localizedDescription)")
        }
    }
    
    func searchItems(keyword: String, email: String) throws -> [EmailItem] {
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
                    throw BackendError.queryFailed("Failed to search with keyword '\(keyword)': \(error.localizedDescription)")
                }
            }
        } catch {
            throw BackendError.unknownError("Occurred in searchItems(): \(error.localizedDescription)")
        }
    }
}

// singleton wrapper
extension DatabaseService {
    enum InitialisationResult {
        case success(DatabaseService)
        case failure(BackendError)
    }
    
    static let getInitResult: InitialisationResult = {
        do {
            return .success(try DatabaseService())
        } catch {
            return .failure(error as! BackendError)
        }
    }()
}
