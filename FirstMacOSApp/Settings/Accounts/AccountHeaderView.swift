//
//  AccountHeaderView.swift
//  FirstMacOSApp
//
//  Created by macbook on 5/9/25.
//

import Cocoa

final class AccountHeaderView: NSCollectionViewItem {
    private lazy var avatarView: AspectImageView = {
        let avatarView = AspectImageView()
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        avatarView.layer?.cornerRadius = 50
        avatarView.clipsToBounds = true
        avatarView.imageScaling = .scaleProportionallyUpOrDown
        avatarView.image = NSImage(systemSymbolName: "person.crop.circle", accessibilityDescription: nil)
        return avatarView
    }()
    
    private lazy var nameLabel: NSTextField = {
        let nameLabel = NSTextField()
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.isEditable = false
        nameLabel.isSelectable = false
        nameLabel.isBezeled = false
        nameLabel.drawsBackground = false
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        return nameLabel
    }()
    
    private lazy var emailLabel: NSTextField = {
        let emailLabel = NSTextField()
        emailLabel.font = .systemFont(ofSize: 14, weight: .regular)
        emailLabel.isEditable = false
        emailLabel.isSelectable = false
        emailLabel.isBezeled = false
        emailLabel.drawsBackground = false
        return emailLabel
    }()
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.spacing = 8
        stackView.alignment = .centerX
        stackView.distribution = .fill
        return stackView
    }()
    
    override func loadView() {
        super.loadView()
        view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
        }
        stackView.addArrangedSubview(avatarView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(emailLabel)
    }
    
    func config(name: String, email: String) {
        nameLabel.stringValue = name
        emailLabel.stringValue = email
    }
}
