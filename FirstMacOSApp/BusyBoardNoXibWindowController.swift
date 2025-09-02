//
//  BusyBoardNoXibWindowController.swift
//  FirstMacOSApp
//
//  Created by macbook on 1/9/25.
//

import Foundation
import Cocoa
import SnapKit

final class BusyBoardNoXibWindowController: NSWindowController {
    init() {
        let rect = NSRect(x: 0, y: 0, width: 720, height: 480)
        let style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        let window = NSWindow(contentRect: rect, styleMask: style, backing: .buffered, defer: false)
        
        window.title = "No Xib window"
        window.isReleasedWhenClosed = false
        window.contentViewController = BusyBoardViewController()
        window.makeKeyAndOrderFront(nil)
        window.center()
        window.makeFirstResponder(nil)
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
