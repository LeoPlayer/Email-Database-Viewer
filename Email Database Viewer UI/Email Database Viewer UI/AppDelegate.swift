//
//  AppDelegate.swift
//  Email Database Viewer UI
//
//  Created by プレイヤー怜央 on 2025/12/15.
//


import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.async {
            self.disableWindowTabbing()
        }
    }
    
    // disables tabs, and the two options under View in the menubar
    private func disableWindowTabbing() {
        for window in NSApp.windows {
            window.tabbingMode = .disallowed
            window.styleMask.remove(.unifiedTitleAndToolbar)
        }
    }
}
