//
//  SideBarAccountItemView.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Cocoa
import Foundation

final class SideBarAccountItemView: NSView {
    private lazy var nameLabel: NSTextField = {
        let label = NSTextField()
        label.isSelectable = false
        label.isEditable = false
        label.drawsBackground = false
        label.isBezeled = false
        label.isBordered = false
        label.textColor = .labelColor
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var appleAccountLabel: NSTextField = {
        let label = NSTextField()
        label.isSelectable = false
        label.isEditable = false
        label.drawsBackground = false
        label.isBezeled = false
        label.isBordered = false
        label.textColor = .labelColor
        label.font = .labelFont(ofSize: 12)
        return label
    }()
    
    private lazy var avatarImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.clipsToBounds = true
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var horizontalStackView: NSStackView = {
        let stackView = NSStackView()
        stackView.spacing = 16
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var verticalStackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
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
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let avatarContainer = NSView()
        avatarContainer.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        avatarContainer.clipsToBounds = true
        avatarContainer.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        horizontalStackView.addArrangedSubview(avatarContainer)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(appleAccountLabel)
    }
    
    func bindData(node: SideBarNode) {
        avatarImageView.image = NSImage(systemSymbolName: node.symbolName ?? "", accessibilityDescription: nil)
        nameLabel.stringValue = node.title
        appleAccountLabel.stringValue = node.subtitle ?? ""
    }
}
