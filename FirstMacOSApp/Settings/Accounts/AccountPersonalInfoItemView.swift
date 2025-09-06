//
//  AccountPersonalInfoItemView.swift
//  FirstMacOSApp
//
//  Created by macbook on 5/9/25.
//
import Cocoa

final class AccountPersonalInfoCell: NSCollectionViewItem {
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
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func config(items: [AccountItem]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, item) in items.enumerated() {
            let itemView = AccountPersonalInfoItemView()
            stackView.addArrangedSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
            itemView.onTap = {

            }
            let isLast = index == items.count - 1
            switch item {
            case let .personalInfo(title, icon):
                itemView.config(title: title, icon: icon, isLast: isLast)
            case let .icloud(title, subtitle, icon):
                itemView.config(title: title, icon: icon, subtitle: subtitle, isLast: isLast)
            default:
                break
            }
        }
    }
}

final class AccountPersonalInfoItemView: HighlightableView {
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.spacing = 16
        stackView.alignment = .centerY
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var iconImageView: AspectImageView = {
        let imageView = AspectImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.imageAlignment = .alignCenter
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
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
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var arrowImageView: AspectImageView = {
        let imageView = AspectImageView()
        imageView.image = NSImage(systemSymbolName: "chevron.right", accessibilityDescription: nil)
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
        return imageView
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
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(arrowImageView)
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView.snp.horizontalEdges)
            make.bottom.equalToSuperview()
        }
    }
    
    func config(title: String, icon: String, subtitle: String? = nil, isLast: Bool) {
        iconImageView.image = NSImage(systemSymbolName: icon, accessibilityDescription: nil)
        titleLabel.stringValue = title
        divider.isHidden = isLast
        if let subtitle = subtitle, !subtitle.isEmpty {
            subtitleLabel.isHidden = false
            subtitleLabel.stringValue = subtitle
        } else {
            subtitleLabel.isHidden = true
            subtitleLabel.stringValue = ""
        }
    }
}
