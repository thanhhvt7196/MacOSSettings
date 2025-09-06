//
//  SettingsContentHostViewController.swift
//  FirstMacOSApp
//
//  Created by macbook on 3/9/25.
//

import Foundation
import Cocoa
import SnapKit

final class SettingsContentHostViewController: NSViewController {
    private(set) var currentVC: NSViewController?
    
    private lazy var navigationBar: ContentNavigationBar = {
        let navigationBar = ContentNavigationBar()
        return navigationBar
    }()
    
    private lazy var contentView = NSView()
    
//    override func loadView() {
//        super.loadView()
//        let view = NSVisualEffectView()
//        view.material = .underPageBackground
//        view.blendingMode = .behindWindow
//        view.state = .followsWindowActiveState
//        self.view = view
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.distribution = .fill
        stackView.alignment = .centerX
        stackView.spacing = 0
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.addArrangedSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(44)
        }
        stackView.addArrangedSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    func show(_ vc: NSViewController) {
        let previousVC = currentVC
        if let previousVC = previousVC {
            replaceController(vc, previousVC: previousVC)
        } else {
            addChildController(vc)
        }
        navigationBar.setTitle(vc.title)
    }
    
    func addChildController(_ vc: NSViewController) {
        addChild(vc)
        contentView.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        currentVC = vc
        vc.view.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    func replaceController(_ vc: NSViewController, previousVC: NSViewController) {
        addChild(vc)
        transition(from: previousVC, to: vc, options: [.crossfade]) { [weak self] in
            previousVC.removeFromParent()
            self?.currentVC = vc
        }
        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        vc.view.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
