//
//  SettingsWindowController.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Cocoa
import Foundation

final class SettingsWindowController: NSWindowController {
    private let windowSize = 700.0
    private let minWindowHeight = 500.0
    private var oldFrame: NSRect = .zero
    
    init() {
        let splitVC = NSSplitViewController()
        
        let sidebarVC = SidebarViewController()
        let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebarVC)
        
        let contentVC = NSViewController()
        let contentItem = NSSplitViewItem(viewController: contentVC)
        
        splitVC.addSplitViewItem(sidebarItem)
        splitVC.addSplitViewItem(contentItem)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: windowSize, height: windowSize),
            styleMask: [.titled, .miniaturizable, .resizable, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.minSize.height = minWindowHeight
        window.collectionBehavior.remove(.fullScreenPrimary)
        window.backgroundColor = .controlBackgroundColor
        
        let toolbar = NSToolbar(identifier: "MainToolbar")
        toolbar.showsBaselineSeparator = false
        toolbar.sizeMode = .small
        window.toolbar = toolbar
        window.toolbarStyle = .unified
        
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.contentViewController = splitVC
        super.init(window: window)
        
        if let zoomButton = window.standardWindowButton(.zoomButton) {
            zoomButton.target = self
            zoomButton.action = #selector(handleZoom)
        }
        
        window.delegate = self
        oldFrame = window.frame
    }
    
    @objc private func handleZoom() {
        print("zoom nè")
        guard let window = window, let visibleFrame = NSScreen.main?.visibleFrame else {
            return
        }
        if window.frame.height == visibleFrame.height, oldFrame != .zero {
            window.setFrame(oldFrame, display: true, animate: true)
        } else {
            oldFrame = window.frame
            window.setFrame(NSRect(x: window.frame.origin.x, y: 0, width: windowSize, height: visibleFrame.height), display: true, animate: true)
        }        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsWindowController: NSWindowDelegate {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        let screenFrame = sender.screen?.visibleFrame ?? NSScreen.main?.visibleFrame ?? .zero
        
        var newSize = frameSize
        newSize.width = windowSize
        let newHeight = max(minWindowHeight, min(frameSize.height, screenFrame.height))
        newSize.height = newHeight
        return newSize
    }
}
