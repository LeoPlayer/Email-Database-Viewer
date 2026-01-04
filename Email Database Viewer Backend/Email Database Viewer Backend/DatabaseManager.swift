//
//  DatabaseManager.swift
//  Email Database Viewer Backend
//
//  Created by プレイヤー怜央 on 2026/01/04.
//

import GRDB
import Foundation
import SharedConstants

class DatabaseManager {
    private var dbQueue: DatabaseQueue
    private var migrator: DatabaseMigrator = DatabaseMigrator()
        
    init() throws {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw BackendError.unknownError("Could not find document directory")
        }
        
        let databasePath = documentsDirectory.appendingPathComponent(DatabaseConstants.databaseFileName)
        
        do {
            dbQueue = try DatabaseQueue(path: databasePath.path)
            print("Connected to SQLite database \(databasePath.path) successfully")
        } catch {
            throw BackendError.connectionFailed("path name = \(databasePath.path), error message: \(error.localizedDescription)")
        }
        
        try setMigrator()
        try dbQueue.read { db in
            if try migrator.hasBeenSuperseded(db) {
                throw BackendError.unknownError("the database is created from a newer version of the app")
            }
        }
        
        do {
            if try isDatabaseEmpty() {
                try applyMigration()
            }
        } catch {
            throw BackendError.unknownError("unable to check database for tables: \(error)")
        }
    }
    
    private func isDatabaseEmpty() throws -> Bool {
        return try dbQueue.read { db in
            let command = """
                SELECT  COUNT(*)
                FROM    sqlite_master
                WHERE   type = 'table' AND name NOT LIKE 'sqlite_%'
            """
            return (try Int.fetchOne(db, sql: command) ?? 0) == 0
        }
    }
    
    public func getDbQueue() -> DatabaseQueue {
        return dbQueue
    }
    
    public func requiresMigration() throws -> Bool {
        let command = """
            SELECT      identifier
            FROM        grdb_migrations
            ORDER BY    rowid DESC
            LIMIT       1
        """
        let lastMigrationName = try dbQueue.read { db in
            return try String.fetchOne(db, sql: command)!
        }
        
        return lastMigrationName != migrator.migrations.last
    }
    
    public func applyMigration() throws {
        try migrator.migrate(dbQueue)
    }
    
    private func setMigrator() throws {
        migrator.registerMigration("v0.2") { db in
            try db.create(table: "temp_table_name", ifNotExists: true) { t in
                t.primaryKey("id", .text)
                t.column("sender_name", .text)
                t.column("sender_address", .text).notNull()
                t.column("receiver_name", .text)
                t.column("receiver_address", .text).notNull()
                t.column("email_title", .text).notNull()
                t.column("email_content", .text).notNull()
                t.column("email_date", .datetime).notNull()
            }
        }
        
        // register newer migrations last
    }
}
