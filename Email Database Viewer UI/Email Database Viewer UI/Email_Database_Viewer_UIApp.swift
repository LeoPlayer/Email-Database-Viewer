//
//  Email_Database_Viewer_UIApp.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/10.
//

import SwiftUI

@main
struct Email_Database_Viewer_UIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            // removes new window command
            CommandGroup(replacing: .newItem) { }
        }
    }
}
