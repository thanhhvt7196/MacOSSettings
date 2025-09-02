//
//  SideBarItemView.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Cocoa
import Foundation
import SnapKit

final class SideBarItemView: NSView {
    private lazy var nameLabel: NSTextField = {
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
    
    private lazy var iconImageView: AspectImageView = {
        let imageView = AspectImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
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
        
        horizontalStackView.addArrangedSubview(iconImageView)
        horizontalStackView.addArrangedSubview(nameLabel)
    }
    
    func bindData(node: SideBarNode) {
        nameLabel.stringValue = node.title
        let image = NSImage(systemSymbolName: node.symbolName ?? "", accessibilityDescription: nil)
        
        image?.isTemplate = true
        iconImageView.image = image
        iconImageView.contentTintColor = .systemBlue
    }
}

