//
//  SettingsViewController.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Foundation
import Cocoa
import RxSwift

final class SettingsViewController: NSViewController {
    override func loadView() {
        super.loadView()
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
    }
}
