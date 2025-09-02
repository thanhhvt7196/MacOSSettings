//
//  SpeakLineViewController.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Cocoa
import Foundation
import RxCocoa
import RxSwift

final class SpeakLineViewController: NSViewController {
    private let disposeBag = DisposeBag()
    
    private let speechSynth = NSSpeechSynthesizer()
    
    private let voices = NSSpeechSynthesizer.availableVoices
    
    private lazy var tableContainer: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.scrollerStyle = .legacy
        scrollView.hasHorizontalScroller = false
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = .init()
        return scrollView
    }()
    
    private lazy var tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Voice"))
        column.title = "Voice"
        column.width = 150
        tableView.addTableColumn(column)
        
        let localeColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Locale"))
        localeColumn.title = "Locale"
        localeColumn.width = 150

        tableView.addTableColumn(localeColumn)
        tableView.headerView = NSTableHeaderView()
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.allowsEmptySelection = false
        tableView.style = .plain
        tableView.columnAutoresizingStyle = .noColumnAutoresizing
        return tableView
    }()
    
    private lazy var textField: NSTextField = {
        let textField = NSTextField()
        textField.placeholderString = "Enter text to be spoken"
        return textField
    }()
    
    private lazy var textView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.placeholderString = "Enter text to be spoken"
        textView.isEditable = true
        textView.isSelectable = true
        textView.font = .systemFont(ofSize: 14)
        textView.autoresizingMask = [.width]
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return textView
    }()
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.scrollerStyle = .overlay
        scrollView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(100)
            make.width.greaterThanOrEqualTo(100)
        }
        return scrollView
    }()
    
    private lazy var stopButton: NSButton = {
        let button = NSButton()
        button.title = "Stop"
        return button
    }()
    
    private lazy var speakButton: NSButton = {
        let button = NSButton()
        button.title = "Speak"
        return button
    }()
    
    override func loadView() {
        super.loadView()
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 720, height: 300))
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    private func setupUI() {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.spacing = 16
        stackView.alignment = .trailing
        stackView.distribution = .fill
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(30)
        }
        
        let buttonStack = NSStackView()
        buttonStack.orientation = .horizontal
        buttonStack.spacing = 16
        buttonStack.alignment = .centerY
        buttonStack.distribution = .fill
        
        
        let contentStackView = NSStackView()
        contentStackView.orientation = .horizontal
        contentStackView.spacing = 16
        contentStackView.alignment = .top
        contentStackView.distribution = .fill
        contentStackView.addArrangedSubview(scrollView)
        contentStackView.addArrangedSubview(tableContainer)
        tableContainer.snp.makeConstraints { make in
            make.width.equalTo(350)
        }
        
        stackView.addArrangedSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        stackView.addArrangedSubview(buttonStack)
        buttonStack.addArrangedSubview(stopButton)
        buttonStack.addArrangedSubview(speakButton)
    }
    
    private func setupRx() {
        textView.rx.string
            .distinctUntilChanged()
            .map { !$0.isEmpty }
            .bind(to: speakButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        speakButton.rx.tap
            .withLatestFrom(textView.rx.string)
            .subscribe(with: self, onNext: { vc, text in
                vc.speechSynth.startSpeaking(text)
            })
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .subscribe(with: self, onNext: { vc, _ in
                vc.speechSynth.stopSpeaking()
            })
            .disposed(by: disposeBag)
    }
    
    private func displayName(for voice: NSSpeechSynthesizer.VoiceName) -> String {
        let attrs = NSSpeechSynthesizer.attributes(forVoice: voice)
        return (attrs[.name] as? String) ?? voice.rawValue
    }
    
    private func displayLocale(for voice: NSSpeechSynthesizer.VoiceName) -> String? {
        let attrs = NSSpeechSynthesizer.attributes(forVoice: voice)
        return (attrs[.localeIdentifier] as? String)
    }
}

extension SpeakLineViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return voices.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier("VoiceCell")
        let info: String? = {
            switch tableColumn?.identifier.rawValue {
            case "Voice":
                return displayName(for: voices[row])
            case "Locale":
                return displayLocale(for: voices[row])
            default:
                return nil
            }
        }()
        
        if let cell = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = info ?? ""
            return cell
        } else {
            // Tạo cell lần đầu
            let cell = NSTableCellView()
            cell.identifier = id
            
            let tf = NSTextField(labelWithString: info ?? "")
            tf.alignment = .left
            cell.addSubview(tf)
            cell.textField = tf
            
            tf.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.centerY.equalToSuperview().inset(4)
                make.top.greaterThanOrEqualToSuperview().inset(4)
            }
            return cell
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard voices.indices.contains(tableView.selectedRow) else {
            return
        }
        let voice = voices[tableView.selectedRow]
        speechSynth.setVoice(voice)
        tableView.deselectRow(tableView.selectedRow)
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
}
