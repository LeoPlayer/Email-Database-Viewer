//
//  BackendAPI.swift
//  Email Database Viewer Backend
//
//  Created by プレイヤー怜央 on 2025/12/12.
//

import Foundation

public class BackendAPI {
    private let databaseService = DatabaseService.instance
    
    public init() { }
    
    public func populate() async throws {
        try await databaseService.createTable()
        try await databaseService.insertItems(
            [
                Item(id: "1", name: "James", description: "James Info"),
                Item(id: "2", name: "John", description: "John Info"),
                Item(id: "3", name: "Robert")
            ]
        )
    }
    
    public func searchDatabase(_ searchTerm: String? = "") throws -> [Item] {
        return try databaseService.searchItems(searchTerm ?? "")
    }
}
