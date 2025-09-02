//
//  RGBWindowController.swift
//  FirstMacOSApp
//
//  Created by macbook on 1/9/25.
//

import Cocoa
import Foundation

class RGBWindowController: NSWindowController {
    @IBOutlet private var colorWell: NSColorWell!
    @IBOutlet private var redSlider: NSSlider!
    @IBOutlet private var gSlider: NSSlider!
    @IBOutlet private var bSlider: NSSlider!
    
    override var windowNibName: NSNib.Name? {
        return "RGBWindowController"
    }
    
    private var green: CGFloat = 0 {
        didSet {
            updateColor()
        }
    }
    private var red: CGFloat = 0 {
        didSet {
            updateColor()
        }
    }
    private var blue: CGFloat = 0 {
        didSet {
            updateColor()
        }
    }
    
    private func updateColor() {
        colorWell.color = NSColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        redSlider.minValue = 0
        [redSlider, gSlider, bSlider].forEach {
            $0?.minValue = 0
            $0?.maxValue = 1
            $0?.isContinuous = true
        }
        red = redSlider.doubleValue
        green = gSlider.doubleValue
        blue = bSlider.doubleValue
        updateColor()
        colorWell.target = self
        colorWell.action = #selector(colorWellAction(_:))
        colorWell.isContinuous = true
    }
    
    @objc private func colorWellAction(_ sender: NSColorWell) {
        redSlider.doubleValue = sender.color.redComponent
        gSlider.doubleValue = sender.color.greenComponent
        bSlider.doubleValue = sender.color.blueComponent
    }
    
    @IBAction func rSliderAction(_ sender: NSSlider) {
        red = sender.doubleValue
    }
    
    @IBAction func gSliderAction(_ sender: NSSlider) {
        green = sender.doubleValue
    }
    
    @IBAction func bSliderAction(_ sender: NSSlider) {
        blue = sender.doubleValue
    }
}
