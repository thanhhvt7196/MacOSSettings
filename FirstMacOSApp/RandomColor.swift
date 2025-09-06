//
//  RandomColor.swift
//  FirstMacOSApp
//
//  Created by macbook on 3/9/25.
//
import Cocoa

extension NSColor {
    static func random() -> NSColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return NSColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
