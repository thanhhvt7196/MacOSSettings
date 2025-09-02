//
//  SpeakLineWindowController.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Cocoa
import Foundation

final class SpeakLineWindowController: NSWindowController {
    init() {
        let viewController = SpeakLineViewController()
        let window = NSWindow(contentViewController: viewController)
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.title = "Speak Line"
//        window.contentAspectRatio = .init(width: 16, height: 10)
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
