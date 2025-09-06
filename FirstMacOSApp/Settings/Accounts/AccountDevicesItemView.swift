//
//  AccountDevicesItemView.swift
//  FirstMacOSApp
//
//  Created by macbook on 6/9/25.
//

import Cocoa

final class AccountDevicesCell: NSCollectionViewItem {
    private lazy var titleLabel: NSTextField = {
        let titleLabel = NSTextField()
        titleLabel.isEditable = false
        titleLabel.isSelectable = false
        titleLabel.isBezeled = false
        titleLabel.drawsBackground = false
        titleLabel.textColor = .labelColor
        titleLabel.backgroundColor = .red
        return titleLabel
    }()
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.spacing = 0
        stackView.alignment = .centerX
        stackView.distribution = .fillEqually
        stackView.wantsLayer = true
        stackView.layer?.cornerRadius = 8
        stackView.layer?.borderWidth = 1
        stackView.layer?.borderColor = NSColor.separatorColor.cgColor
        return stackView
    }()
    
    override func loadView() {
        super.loadView()
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(16)
            
        }
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func config(title: String, items: [AccountItem]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        titleLabel.stringValue = title
        
        for (index, item) in items.enumerated() {
            guard case .device(let device) = item else {
                return
            }
            let itemView = AccountDevicesItemView()
            stackView.addArrangedSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
            itemView.onTap = {

            }
            let isLast = index == items.count - 1
            itemView.config(device: device, isLast: isLast)
        }
    }
}

final class AccountDevicesItemView: HighlightableView {
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.spacing = 16
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var verticalStackView: NSStackView = {
        let stackView = NSStackView()
        stackView.spacing = 0
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var iconImageView: AspectImageView = {
        let imageView = AspectImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.imageAlignment = .alignCenter
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        return imageView
    }()
    
    private lazy var titleLabel: NSTextField = {
        let label = NSTextField()
        label.isSelectable = false
        label.isEditable = false
        label.isBezeled = false
        label.textColor = .labelColor
        label.drawsBackground = false
        label.alignment = .left
        return label
    }()
    
    private lazy var subtitleLabel: NSTextField = {
        let label = NSTextField()
        label.isSelectable = false
        label.isEditable = false
        label.isBezeled = false
        label.textColor = .secondaryLabelColor
        label.drawsBackground = false
        label.alignment = .left
        return label
    }()
    
    private lazy var divider: NSView = {
        let divider = NSView()
        divider.wantsLayer = true
        divider.layer?.backgroundColor = NSColor.separatorColor.cgColor
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return divider
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
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
            make.bottom.equalTo(stackView.snp.bottom)
        }
    }
    
    func config(device: IcloudDevice, isLast: Bool) {
        iconImageView.image = NSImage(systemSymbolName: device.image, accessibilityDescription: nil)
        titleLabel.stringValue = device.title
        subtitleLabel.stringValue = device.subtitle
        divider.isHidden = isLast
    }
}
