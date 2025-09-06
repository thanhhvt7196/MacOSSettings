//
//  AccountFooterView.swift
//  FirstMacOSApp
//
//  Created by macbook on 6/9/25.
//
import Cocoa

@MainActor
protocol AccountFooterDelegate: AnyObject {
    func signoutAction()
    func helpAction()
}

final class AccountFooterView: NSView {
    weak var delegate: AccountFooterDelegate?
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.spacing = 16
        stackView.alignment = .centerY
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var signoutButton: NSButton = {
        let button = NSButton()
        button.title = "Sign Out"
        button.action = #selector(signoutAction)
        button.target = self
        return button
    }()
    
    private lazy var helpButton: NSButton = {
        let button = NSButton()
        button.bezelStyle = .helpButton
        button.title = ""
        button.action = #selector(helpAction)
        button.target = self
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
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(signoutButton)
        let spacer = NSView()
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(helpButton)
    }
    
    @objc private func signoutAction() {
        delegate?.signoutAction()
    }
    
    @objc private func helpAction() {
        delegate?.helpAction()
    }
}
