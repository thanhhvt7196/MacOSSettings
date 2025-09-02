//
//  Divider.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Cocoa

final class Divider: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.separatorColor.cgColor
    }
}
