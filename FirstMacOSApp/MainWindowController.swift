//
//  MainWindowController.swift
//  FirstMacOSApp
//
//  Created by macbook on 1/9/25.
//

import Cocoa
import Foundation

class MainWindowController: NSWindowController {
    @IBOutlet private var generateButton: NSButton!
    @IBOutlet private var textfield: NSTextField!
    
    override var windowNibName: NSNib.Name? {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        textfield.textColor = .red
        textfield.stringValue = "hahahaha"
        
        generateButton.action = #selector(handleGenerateButton)
    }
    
    @objc private func handleGenerateButton() {
        textfield.stringValue = generateRandomString(length: 6)
    }
}
