//
//  Constants.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/12.
//

import Foundation

public enum Status {
    case loading
    case loaded
}

public struct DatabaseError: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
}
