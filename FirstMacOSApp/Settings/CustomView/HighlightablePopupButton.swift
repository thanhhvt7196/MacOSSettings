//
//  HighlightablePopupButton.swift
//  FirstMacOSApp
//
//  Created by macbook on 6/9/25.
//

import Cocoa

class HighlightablePopupButton: NSPopUpButton {
    override func mouseEntered(with event: NSEvent) {
        layer?.backgroundColor = NSColor.alternateSelectedControlTextColor.cgColor.copy(alpha: 0.2)
    }
    
    override func mouseExited(with event: NSEvent) {
        layer?.backgroundColor = .clear
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
}
