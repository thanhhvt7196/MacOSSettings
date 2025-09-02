//
//  SidebarViewController.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Foundation
import Cocoa
import SnapKit
import RxSwift
import RxCocoa

final class SidebarViewController: NSViewController {
    private let notes = [
        .account,
        SideBarNode(
            title: "Connectivity",
            children: [
                SideBarNode(title: "Wifi", symbolName: "wifi.square.fill"),
                SideBarNode(title: "Bluetooth", symbolName: "bolt.horizontal"),
                SideBarNode(title: "Network", symbolName: "network"),
                SideBarNode(title: "Battery", symbolName: "battery.100")
            ],
            isGroup: true
        ),
        SideBarNode(
            title: "System",
            children: [
                SideBarNode(title: "General", symbolName: "gearshape"),
                SideBarNode(title: "Accessibility", symbolName: "figure.wave"),
                SideBarNode(title: "Appearance", symbolName: "paintbrush"),
                SideBarNode(title: "Apple Intelligence & Siri", symbolName: "sparkles"),
                SideBarNode(title: "Control Center", symbolName: "switch.2"),
                SideBarNode(title: "Desktop & Dock", symbolName: "dock.rectangle"),
                SideBarNode(title: "Displays", symbolName: "display"),
                SideBarNode(title: "Screen Saver", symbolName: "photo.on.rectangle"),
                SideBarNode(title: "Spotlight", symbolName: "magnifyingglass"),
                SideBarNode(title: "Wallpaper", symbolName: "photo"),
                SideBarNode(title: "Notifications", symbolName: "bell.badge"),
                SideBarNode(title: "Sound", symbolName: "speaker.wave.2"),
                SideBarNode(title: "Focus", symbolName: "moon")
            ],
            isGroup: true
        ),
        
        SideBarNode(
            title: "Security",
            children: [
                SideBarNode(title: "Lock Screen", symbolName: "lock"),
                SideBarNode(title: "Privacy & Security", symbolName: "hand.raised"),
                SideBarNode(title: "Touch ID & Password", symbolName: "touchid"),
                SideBarNode(title: "Users & Groups", symbolName: "person.2")
            ],
            isGroup: true
        ),
        
        SideBarNode(
            title: "Services",
            children: [
                SideBarNode(title: "Internet Accounts", symbolName: "at"),
                SideBarNode(title: "Game Center", symbolName: "gamecontroller"),
                SideBarNode(title: "iCloud", symbolName: "icloud"),
                SideBarNode(title: "Wallet & Apple Pay", symbolName: "creditcard")
            ],
            isGroup: true
        ),
        
        SideBarNode(
            title: "Input",
            children: [
                SideBarNode(title: "Keyboard", symbolName: "keyboard"),
                SideBarNode(title: "Trackpad", symbolName: "rectangle.and.hand.point.up.left"),
                SideBarNode(title: "Printers & Scanners", symbolName: "printer")
            ],
            isGroup: true
        )
    ]
    
    private var isFirstLaunch = true
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var outlineView: NSOutlineView = {
        let view = NSOutlineView()
        view.headerView = nil
        view.focusRingType = .none
        view.dataSource = self
        view.delegate = self
        view.intercellSpacing = .zero
        return view
    }()
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.scrollerStyle = .overlay
        scrollView.hasVerticalScroller = true
        scrollView.verticalScroller?.controlSize = .small
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = .init()
        scrollView.borderType = .noBorder
        scrollView.focusRingType = .none
        return scrollView
    }()
    
    private lazy var searchField: NSSearchField = {
        let searchField = NSSearchField()
        searchField.placeholderString = "Search"
        searchField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        searchField.refusesFirstResponder = true
        searchField.controlSize = .large
        (searchField.cell as? NSSearchFieldCell)?.controlSize = .large
        return searchField
    }()
    
    override func loadView() {
        super.loadView()
        self.view = NSView()
        view.snp.makeConstraints { make in
            make.width.equalTo(220)
        }
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        
        let searchFieldContainer = NSView()
        searchFieldContainer.addSubview(searchField)
        searchFieldContainer.focusRingType = .default
        
        stackView.addArrangedSubview(searchFieldContainer)
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("SidebarColumn"))
        outlineView.addTableColumn(column)
        outlineView.outlineTableColumn = column
        
        scrollView.documentView = outlineView
        scrollView.hasVerticalScroller = true
        stackView.addArrangedSubview(scrollView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if isFirstLaunch {
            isFirstLaunch = false
            layoutSubviews()
            outlineView.expandItem(nil, expandChildren: true)
            if let firstLeaf = firstSelectableNode() {
                let row = outlineView.row(forItem: firstLeaf)
                if row >= 0 {
                    outlineView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
                }
            }
        }
    }
    
    private func firstSelectableNode() -> SideBarNode? {
        for note in notes {
            if !note.isGroup { return note }
            if let child = note.children.first {
                return child
            }
        }
        return nil
    }
    
    private func layoutSubviews() {
        guard let window = view.window,
              let contentLayoutGuide = window.contentLayoutGuide as? NSLayoutGuide
        else {
            return
        }
        
        stackView.snp.remakeConstraints { make in
            make.verticalEdges.equalTo(contentLayoutGuide.snp.verticalEdges)
            make.leading.trailing.equalToSuperview()
        }
        
        searchField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
    }
}

extension SidebarViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let node = item as? SideBarNode {
            return node.children.count
        }
        return notes.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item as? SideBarNode)?.isGroup == true
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let node = item as? SideBarNode, node.children.indices.contains(index) {
            return node.children[index]
        }
        return notes[index]
    }
}

extension SidebarViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        guard let node = item as? SideBarNode else { return false }
        return !node.isGroup
    }
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return (item as? SideBarNode)?.isGroup == true
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        guard let node = item as? SideBarNode else {
            return false
        }
        return !node.isGroup
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        guard let node = item as? SideBarNode else {
            return .leastNonzeroMagnitude
        }
        if node.isGroup {
            return 8
        } else {
            return node == .account ? 48 : 24
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let node = item as? SideBarNode else {
            return nil
        }
        if node.isGroup {
            return NSView()
        } else {
            if node == .account {
                let cell = SideBarAccountItemView()
                cell.bindData(node: node)
                return cell
            } else {
                let cell = SideBarItemView()
                cell.bindData(node: node)
                return cell
            }
        }
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        guard outlineView.selectedRow >= 0, let node = outlineView.item(atRow: outlineView.selectedRow) as? SideBarNode else {
            return
        }
    }
}
