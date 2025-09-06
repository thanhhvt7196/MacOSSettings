//
//  ContentNavigationBar.swift
//  FirstMacOSApp
//
//  Created by macbook on 3/9/25.
//

import Foundation
import Cocoa

final class ContentNavigationBar: NSVisualEffectView {
    private lazy var titleLabel: NSTextField = {
        let label = NSTextField()
        label.isSelectable = false
        label.isEditable = false
        label.drawsBackground = false
        label.isBezeled = false
        label.textColor = .labelColor
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var backButton: NSButton = {
        let button = NSButton()
        button.image = NSImage(systemSymbolName: "chevron.left", accessibilityDescription: nil)
        button.isBordered = false
        return button
    }()
    
    private lazy var forwardButton: NSButton = {
        let button = NSButton()
        button.image = NSImage(systemSymbolName: "chevron.right", accessibilityDescription: nil)
        button.isBordered = false
        return button
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
        material = .sidebar
        blendingMode = .withinWindow
        state = .active
        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.spacing = 8
        stackView.alignment = .centerY
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        stackView.addArrangedSubview(forwardButton)
        forwardButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        stackView.addArrangedSubview(titleLabel)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func setTitle(_ value: String?) {
        titleLabel.stringValue = value ?? ""
    }
}
