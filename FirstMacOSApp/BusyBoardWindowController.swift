//
//  BusyBoardWindowController.swift
//  FirstMacOSApp
//
//  Created by macbook on 1/9/25.
//

import Cocoa

class BusyBoardWindowController: NSWindowController {
    @IBOutlet private var sliderValueLabel: NSTextField!
    @IBOutlet private var slider: NSSlider!
    @IBOutlet private var hideRadioButton: NSButton!
    @IBOutlet private var showRadioButton: NSButton!
    @IBOutlet private var resetControlButton: NSButton!
    @IBOutlet private var checkButton: NSButton!
    @IBOutlet private var verticalDivider: NSView!
    @IBOutlet private var horizontalDivider: NSView!
    @IBOutlet private var secretTextView: NSSecureTextField!
    @IBOutlet private var revealButton: NSButton!
    @IBOutlet private var revealTextView: NSTextView!
    
    override var windowNibName: NSNib.Name? {
        return "BusyBoardWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        slider.isVertical = true
        slider.minValue = 0
        slider.maxValue = 100
        slider.numberOfTickMarks = 11
        slider.tickMarkPosition = .leading
        slider.isContinuous = true
        slider.allowsTickMarkValuesOnly = true
        slider.intValue = 0
        
        [verticalDivider, horizontalDivider].forEach {
            $0?.wantsLayer = true
            $0?.layer?.backgroundColor = NSColor.separatorColor.cgColor
        }
        
        showRadioButton.state = .on
        hideRadioButton.state = .off
        sliderValueLabel.stringValue = "\(slider.intValue)"
        
        window?.makeFirstResponder(nil)
    }
    
    @IBAction func resetControlsAction(_ sender: Any) {
        slider.intValue = 0
        showRadioButton.performClick(nil)
    }
    
    @IBAction func showRadioAction(_ sender: NSButton) {
        showRadioButton.state = .on
        hideRadioButton.state = .off
        slider.numberOfTickMarks = 11
        sliderValueLabel.stringValue = "\(slider.intValue)"
    }
    
    @IBAction func hideRadioAction(_ sender: NSButton) {
        showRadioButton.state = .off
        hideRadioButton.state = .on
        slider.numberOfTickMarks = 0
        sliderValueLabel.stringValue = "\(slider.intValue)"
    }
    
    @IBAction func sliderAction(_ sender: NSSlider) {
        sliderValueLabel.stringValue = "\(sender.intValue)"
    }
    
    @IBAction func checkAction(_ sender: NSButton) {
        checkButton.title = checkButton.state == .on ? "Uncheck Me" : "Check Me"
    }
    
    @IBAction func revealAction(_ sender: Any) {
        revealTextView.string = secretTextView.stringValue
    }
}
