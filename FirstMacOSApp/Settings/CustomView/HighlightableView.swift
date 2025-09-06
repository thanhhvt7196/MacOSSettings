//
//  HighlightableView.swift
//  FirstMacOSApp
//
//  Created by macbook on 6/9/25.
//

import Cocoa

class HighlightableView: NSView {
    var onTap: (() -> Void)?
    
    override func mouseDown(with event: NSEvent) {
        layer?.backgroundColor = NSColor.alternateSelectedControlTextColor.cgColor.copy(alpha: 0.2)
    }
    
    override func mouseUp(with event: NSEvent) {
        layer?.backgroundColor = .clear
        if bounds.contains(convert(event.locationInWindow, from: nil)) {
            onTap?()
        }
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if trackingAreas.isEmpty {
            let tracking = NSTrackingArea(
                rect: bounds,
                options: [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect],
                owner: self,
                userInfo: nil)
            
            addTrackingArea(tracking)
        }
    }
    
//    override func mouseEntered(with event: NSEvent) {
//        layer?.backgroundColor = NSColor.alternateSelectedControlTextColor.withAlphaComponent(0.2).cgColor
//    }
//    
//    override func mouseExited(with event: NSEvent) {
//        layer?.backgroundColor = .clear
//    }
}
