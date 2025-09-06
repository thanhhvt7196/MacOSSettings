//
//  WifiViewController.swift
//  FirstMacOSApp
//
//  Created by macbook on 3/9/25.
//


import Foundation
import Cocoa

final class WifiViewController: NSViewController {
    override func loadView() {
        super.loadView()
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.green.cgColor
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
    }
}
