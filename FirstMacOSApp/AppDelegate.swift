//
//  AppDelegate.swift
//  FirstMacOSApp
//
//  Created by macbook on 1/9/25.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindowController: SettingsWindowController?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.set(false, forKey: "NSFullScreenMenuItemEverywhere")
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController = SettingsWindowController()
        mainWindowController?.showWindow(nil)
        mainWindowController?.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        Task(priority: .utility) {
            await SoundServices.shared.loadData()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows: Bool) -> Bool {
        return true
    }
}

