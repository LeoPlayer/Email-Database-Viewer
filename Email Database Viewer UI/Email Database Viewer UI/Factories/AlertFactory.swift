//
//  AlertFactory.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2026/01/04.
//

import SwiftUI
import Foundation

struct AlertFactory {
    static func buildAlert(for alertInfo: AlertInfo) -> Alert {
        switch alertInfo {
        case .error(let title, let message):
            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("OK"))
            )
        case .fatalError(let errorType, let message):
            return Alert(
                title: Text("Fatal Error"),
                message: Text(errorType + ": " + message),
                dismissButton: .destructive(Text("Quit Application")) { exit(0) }
            )
        case .requireMigration(let details):
            return Alert(
                title: Text("Database Requires Migration"),
                message: Text("The database is from a previous version of the app, so will be updated automatically. " +
                              "Quit the application and make a backup of the database if necessary, then click \"Migrate Database\"\n" +
                             details),
                dismissButton: .default(Text("Migrate Database"))
            )
        }
    }
}
