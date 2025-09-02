//
//  BusyBoardViewController.swift
//  FirstMacOSApp
//
//  Created by macbook on 1/9/25.
//

import Foundation
import Cocoa
import RxSwift
import RxCocoa

final class BusyBoardViewController: NSViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var sliderValueLabel: NSTextField = {
        let label = NSTextField()
        label.isSelectable = false
        label.isEditable = false
        label.isBezeled = false
        label.drawsBackground = false
        label.backgroundColor = .yellow
        return label
    }()
    
    private lazy var slider: NSSlider = {
        let slider = NSSlider()
        slider.doubleValue = 0
        slider.minValue = 0
        slider.maxValue = 100
        slider.allowsTickMarkValuesOnly = true
        slider.tickMarkPosition = .leading
        slider.numberOfTickMarks = 0
        slider.isVertical = true
        slider.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        return slider
    }()
    
    private lazy var revealTextView: NSTextView = {
        let textView = NSTextView()
        textView.isSelectable = true
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .textColor
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.heightTracksTextView = false
        return textView
    }()
    
    private lazy var revealScrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.scrollerStyle = .overlay
        scrollView.borderType = .bezelBorder
        scrollView.documentView = revealTextView
        return scrollView
    }()
    
    private lazy var secureTextField: NSSecureTextField = {
        let secureTextField = NSSecureTextField()
        secureTextField.placeholderString = "Enter message here"
        secureTextField.refusesFirstResponder = true
        secureTextField.isBordered = false
        secureTextField.textColor = .textColor
        return secureTextField
    }()
    
    private lazy var revealButton: NSButton = {
        let button = NSButton()
        button.title = "Reveal the secret message"
        return button
    }()
    
    private lazy var showButton: NSButton = {
        let button = NSButton()
        button.setButtonType(.radio)
        button.state = .off
        button.title = "Show slider tick marks"
        return button
    }()
    
    private lazy var hideButton: NSButton = {
        let button = NSButton()
        button.setButtonType(.radio)
        button.state = .on
        button.title = "Hide slider tick marks"
        return button
    }()

    private lazy var checkButton: NSButton = {
        let button = NSButton()
        button.state = .off
        button.title = "Check me"
        button.setButtonType(.switch)
        return button
    }()
    
    private lazy var resetControlButton: NSButton = {
        let button = NSButton()
        button.title = "Reset Controls"
        return button
    }()
    
    override func loadView() {
        super.loadView()
        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        self.view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    private func setupUI() {
        let stackView = NSStackView()
        stackView.alignment = .bottom
        stackView.orientation = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        let firstStack = NSStackView()
        stackView.addArrangedSubview(firstStack)
        firstStack.alignment = .leading
        firstStack.orientation = .vertical
        firstStack.distribution = .fill
        firstStack.spacing = 16
        
        firstStack.snp.makeConstraints { make in
            make.width.equalTo(350)
        }
                
        let firstHorizontalStack = NSStackView()
        firstHorizontalStack.orientation = .horizontal
        firstHorizontalStack.alignment = .bottom
        firstHorizontalStack.distribution = .fill
        firstHorizontalStack.spacing = 16
        firstStack.addArrangedSubview(firstHorizontalStack)
        firstHorizontalStack.addArrangedSubview(slider)
        
        let verticalStackView = NSStackView()
        verticalStackView.orientation = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 16
        
        firstHorizontalStack.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(sliderValueLabel)
        verticalStackView.addArrangedSubview(showButton)
        verticalStackView.addArrangedSubview(hideButton)
        
        firstStack.addArrangedSubview(resetControlButton)
        
        let horizontalDivider = Divider()
        stackView.addArrangedSubview(horizontalDivider)
        horizontalDivider.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(1)
        }
        
        let secondStack = NSStackView()
        secondStack.orientation = .vertical
        secondStack.alignment = .centerX
        secondStack.distribution = .fill
        secondStack.spacing = 16
        stackView.addArrangedSubview(secondStack)
        secondStack.wantsLayer = true
        secondStack.snp.makeConstraints { make in
            make.width.equalTo(firstStack.snp.width)
        }
        
        secondStack.addArrangedSubview(checkButton)
        
        let verticalDivider = Divider()
        secondStack.addArrangedSubview(verticalDivider)
        verticalDivider.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        
        secondStack.addArrangedSubview(secureTextField)
        secureTextField.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(100)
        }
        secondStack.addArrangedSubview(revealButton)
        secondStack.addArrangedSubview(revealScrollView)
        revealScrollView.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(100)
        }
    }
    
    private func setupRx() {
        checkButton.rx.tap
            .subscribe(with: self, onNext: { vc, _ in
                vc.checkButton.title = vc.checkButton.state == .on ? "Uncheck Me" : "Check me"
            })
            .disposed(by: disposeBag)
        
        revealButton.rx.tap
            .subscribe(with: self, onNext: { vc, _ in
                vc.revealTextView.string = vc.secureTextField.stringValue
            })
            .disposed(by: disposeBag)
        
        showButton.rx.tap
            .subscribe(with: self, onNext: { vc, _ in
                vc.showButton.state = .on
                vc.hideButton.state = .off
                vc.slider.numberOfTickMarks = 11
            })
            .disposed(by: disposeBag)
        
        hideButton.rx.tap
            .subscribe(with: self, onNext: { vc, _ in
                vc.showButton.state = .off
                vc.hideButton.state = .on
                vc.slider.numberOfTickMarks = 0
            })
            .disposed(by: disposeBag)
        
        slider.rx.value
            .map { "\(Int($0))"}
            .bind(to: sliderValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
