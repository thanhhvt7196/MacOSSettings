//
//  SoundEffectsSectionView.swift
//  FirstMacOSApp
//
//  Created by macbook on 6/9/25.
//

import Cocoa

final class SoundEffectsSectionView: NSView {
    private lazy var alertView = SoundEffectsAlertView()
    private lazy var outputView = SoundEffectOutputView()
    private lazy var alertVolumeView = SoundEffectAlertVolumeView()

    private lazy var titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "Sound Effects")
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .labelColor
        label.isEditable = false
        label.isSelectable = false
        label.isBezeled = false
        label.drawsBackground = false
        return label
    }()
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.alignment = .leading
        stackView.orientation = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.wantsLayer = true
        stackView.layer?.borderColor = NSColor.separatorColor.cgColor
        stackView.layer?.borderWidth = 1
        stackView.layer?.cornerRadius = 8
        return stackView
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(16)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
        
        stackView.addArrangedSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        addDivider()
        stackView.addArrangedSubview(outputView)
        outputView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        addDivider()
        stackView.addArrangedSubview(alertVolumeView)
        alertVolumeView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    private func addDivider() {
        let divider = NSView()
        divider.wantsLayer = true
        divider.layer?.backgroundColor = NSColor.separatorColor.cgColor
        stackView.addArrangedSubview(divider)
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
