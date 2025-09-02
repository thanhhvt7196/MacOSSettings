//
//  PlaceholderTextView.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import AppKit
import Cocoa
import Foundation

final class PlaceholderTextView: NSTextView {
    var placeholderString: String? {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if string.isEmpty, let placeholder = placeholderString {
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: NSColor.placeholderTextColor,
                .font: font ?? NSFont.systemFont(ofSize: 14)
            ]
            placeholder.draw(in: dirtyRect.insetBy(dx: 4, dy: 0), withAttributes: attrs)
        }
    }
}
