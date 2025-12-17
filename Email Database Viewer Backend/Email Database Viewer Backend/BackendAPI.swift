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
    
    let dateFormatterSydney: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Oceania/Sydney")
        return formatter
    }()
    
    let dateFormatterTokyo: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return formatter
    }()
    
    public func populate() async throws {
        try await databaseService.createTable()
        try await databaseService.insertItems(
            [
                EmailItem(id: "1", senderName: "James", senderAddress: "james.ebb@hotmail.com", receiverName: "Leo", receiverAddress: "leo1@gmail.com", emailTitle: "Meeting", emailContent: "Hi Leo.\nJust writing to let you know that there is a general meeting this Thursday at 2pm. We will be discussing about the direction where we're going with the project, and everyone's opinions on it.\n\nSee you there,\nJames", emailDate: dateFormatterSydney.date(from: "2015/07/12 10:11:23")!),
                EmailItem(id: "2", senderAddress: "john.dale@gmail.com", receiverName: "Leo", receiverAddress: "leo2@outlook.com", emailTitle: "Yo", emailContent: "Wotcha doin' weekend", emailDate: dateFormatterSydney.date(from: "2015/07/13 14:23:45")!),
                EmailItem(id: "3", senderName: "齋藤明", senderAddress: "akira.saito@gmail.com", receiverAddress: "leo1@gmail.com", emailTitle: "またお会いしましょう", emailContent: "齋藤です。\n\n先週は大変お世話になりました。久々にお会いでき、大変嬉しかったです。来週からはまた出張とのことで、大変お忙しい時期にお時間を空けていただき、誠に有り難う御座います。\n\nまたいつかお会いしましょう。", emailDate: dateFormatterTokyo.date(from: "2015/08/09 16:11:57")!)
                
            ]
        )
    }
    
    public func searchDatabase(_ searchTerm: String? = "") throws -> [EmailItem] {
        return try databaseService.searchItems(searchTerm ?? "")
    }
}
