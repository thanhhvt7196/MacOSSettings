//
//  SoundEffectAlertVolumeView.swift
//  FirstMacOSApp
//
//  Created by macbook on 7/9/25.
//

import Cocoa

final class SoundEffectAlertVolumeView: NSView {
    private let minDb = -54.0

    private lazy var slider: NSSlider = {
        let slider = NSSlider()
        slider.minValue = 0
        slider.maxValue = 1
        slider.isEnabled = true
        slider.tickMarkPosition = .below
        slider.isVertical = false
        slider.numberOfTickMarks = 7
        slider.isContinuous = true
        return slider
    }()
    
    private lazy var volumeUpButton: NSButton = {
        let button = NSButton()
        button.isBordered = false
        button.image = NSImage(systemSymbolName: "speaker.wave.3.fill", accessibilityDescription: nil)
        button.title = ""
        button.target = self
        button.action = #selector(volumeUp)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var volumeDownButton: NSButton = {
        let button = NSButton()
        button.isBordered = false
        button.image = NSImage(systemSymbolName: "speaker.fill", accessibilityDescription: nil)
        button.title = ""
        button.target = self
        button.action = #selector(volumeDown)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.spacing = 8
        stackView.alignment = .centerY
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "Alert volume")
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .labelColor
        label.isEditable = false
        label.isSelectable = false
        label.isBezeled = false
        label.drawsBackground = false
        return label
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Task { @MainActor in
            let doubleValue = await SoundServices.shared.getAlertVolume()
            slider.doubleValue = doubleValue
        }
        snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(volumeDownButton)
        stackView.addArrangedSubview(slider)
        slider.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
        stackView.addArrangedSubview(volumeUpButton)
    }
}

extension SoundEffectAlertVolumeView {
    @objc private func volumeUp() {
        print("volume up")
    }
    
    @objc private func volumeDown() {
        print("volume down")
    }
}
