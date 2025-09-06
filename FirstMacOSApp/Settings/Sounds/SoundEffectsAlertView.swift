//
//  SoundEffectsAlertView.swift
//  FirstMacOSApp
//
//  Created by macbook on 7/9/25.
//
import Cocoa

final class SoundEffectsAlertView: NSView {
    private lazy var selectSoundButton: HighlightablePopupButton = {
        let button = HighlightablePopupButton()
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.cornerRadius = 6
        button.clipsToBounds = true
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var playSoundButton: NSButton = {
        let button = NSButton()
        button.cell?.isBezeled = false
        button.title = ""
        button.image = NSImage(systemSymbolName: "play.circle", accessibilityDescription: nil)
        button.isBordered = false
        button.target = self
        button.action = #selector(playSound)
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
        let label = NSTextField(labelWithString: "Alert sound")
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
            let allSounds = await SoundServices.shared.alertSounds
            let currentSound = await SoundServices.shared.getCurrentAlertSound()?.name ?? ""
            selectSoundButton.addItems(withTitles: allSounds.map { $0.name })
            selectSoundButton.selectItem(withTitle: currentSound)
            allSounds.enumerated().forEach { index, sound in
                selectSoundButton.item(at: index)?.representedObject = sound
            }
            selectSoundButton.target = self
            selectSoundButton.action = #selector(didSelectSound(_:))
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
        stackView.addArrangedSubview(selectSoundButton)
        selectSoundButton.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        stackView.addArrangedSubview(playSoundButton)
        playSoundButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
    }
}

extension SoundEffectsAlertView {
    @objc private func didSelectSound(_ sender: NSPopUpButton) {
        guard let sound = sender.selectedItem?.representedObject as? AlertSound else {
            return
        }
        Task {
            await SoundServices.shared.setCurrentAlert(sound: sound)
        }
    }
    
    @objc private func playSound() {
        guard let sound = selectSoundButton.selectedItem?.representedObject as? AlertSound else {
            return
        }
        Task {
            await SoundServices.shared.playSound(url: sound.url)
        }
    }
}
