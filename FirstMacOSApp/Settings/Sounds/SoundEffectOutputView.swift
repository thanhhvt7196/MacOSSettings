//
//  SoundEffectOutputView.swift
//  FirstMacOSApp
//
//  Created by macbook on 7/9/25.
//
import Cocoa

final class SoundEffectOutputView: NSView {
    private lazy var selectOutputButton: HighlightablePopupButton = {
        let button = HighlightablePopupButton()
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.cornerRadius = 6
        button.clipsToBounds = true
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
        let label = NSTextField(labelWithString: "Play sound effects through")
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
            let allDevices = await SoundServices.shared.outputDevices
            let currentDeviceName = await SoundServices.shared.getCurrentOutputId()
            selectOutputButton.addItems(withTitles: allDevices.map { $0.name })
            allDevices.enumerated().forEach { index, device in
                selectOutputButton.item(at: index)?.representedObject = device
            }
            selectOutputButton.insertItem(withTitle: SoundServices.defaultOutputName, at: 0)
            selectOutputButton.selectItem(withTitle: currentDeviceName)

            selectOutputButton.target = self
            selectOutputButton.action = #selector(didSelectDevice(_:))
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
        stackView.addArrangedSubview(selectOutputButton)
        selectOutputButton.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
    }
}

extension SoundEffectOutputView {
    @objc private func didSelectDevice(_ sender: NSPopUpButton) {
        guard let device = sender.selectedItem?.representedObject as? AudioDevice else {
            return
        }
//        Task {
//            await SoundServices.shared.setCurrentAlert(sound: sound)
//        }
    }
}
