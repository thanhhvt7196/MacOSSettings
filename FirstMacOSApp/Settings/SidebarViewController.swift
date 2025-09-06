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

@MainActor
protocol SideBarViewControllerDelegate: AnyObject {
    func sideBar(_ vc: SidebarViewController, didSelectItem: SideBarNodeItemType)
}

final class SidebarViewController: NSViewController {
    weak var delegate: SideBarViewControllerDelegate?
    
    var selectedItem: SideBarNodeItemType? {
        return (outlineView.item(atRow: outlineView.selectedRow) as? SideBarNode)?.type
    }
    
    private let notes = [
        .account,
        SideBarNode(
            title: "Connectivity",
            children: [
                SideBarNode(title: "Wifi", symbolName: "wifi.square.fill", type: .wifi),
                SideBarNode(title: "Bluetooth", symbolName: "bolt.horizontal", type: .bluetooth),
                SideBarNode(title: "Network", symbolName: "network", type: .network),
                SideBarNode(title: "Battery", symbolName: "battery.100", type: .battery)
            ],
            isGroup: true,
            type: nil
        ),
        SideBarNode(
            title: "System",
            children: [
                SideBarNode(title: "General", symbolName: "gearshape", type: .general),
                SideBarNode(title: "Accessibility", symbolName: "figure.wave", type: .accessibility),
                SideBarNode(title: "Appearance", symbolName: "paintbrush", type: .appearance),
                SideBarNode(title: "Apple Intelligence & Siri", symbolName: "sparkles", type: .appleIntelligence),
                SideBarNode(title: "Control Center", symbolName: "switch.2", type: .controlCenter),
                SideBarNode(title: "Desktop & Dock", symbolName: "dock.rectangle", type: .desktopDock),
                SideBarNode(title: "Displays", symbolName: "display", type: .displays),
                SideBarNode(title: "Screen Saver", symbolName: "photo.on.rectangle", type: .screenSaver),
                SideBarNode(title: "Spotlight", symbolName: "magnifyingglass", type: .spotlight),
                SideBarNode(title: "Wallpaper", symbolName: "photo", type: .wallpaper),
                SideBarNode(title: "Notifications", symbolName: "bell.badge", type: .notifications),
                SideBarNode(title: "Sound", symbolName: "speaker.wave.2", type: .sound),
                SideBarNode(title: "Focus", symbolName: "moon", type: .focus)
            ],
            isGroup: true,
            type: nil
        ),
        
        SideBarNode(
            title: "Security",
            children: [
                SideBarNode(title: "Lock Screen", symbolName: "lock", type: .lockScreen),
                SideBarNode(title: "Privacy & Security", symbolName: "hand.raised", type: .privacy),
                SideBarNode(title: "Touch ID & Password", symbolName: "touchid", type: .touchId),
                SideBarNode(title: "Users & Groups", symbolName: "person.2", type: .userGroup)
            ],
            isGroup: true,
            type: nil
        ),
        
        SideBarNode(
            title: "Services",
            children: [
                SideBarNode(title: "Internet Accounts", symbolName: "at", type: .internetAccount),
                SideBarNode(title: "Game Center", symbolName: "gamecontroller", type: .gameCenter),
                SideBarNode(title: "iCloud", symbolName: "icloud", type: .icloud),
                SideBarNode(title: "Wallet & Apple Pay", symbolName: "creditcard", type: .wallet)
            ],
            isGroup: true,
            type: nil
        ),
        
        SideBarNode(
            title: "Input",
            children: [
                SideBarNode(title: "Keyboard", symbolName: "keyboard", type: .keyboard),
                SideBarNode(title: "Trackpad", symbolName: "rectangle.and.hand.point.up.left", type: .trackpad),
                SideBarNode(title: "Printers & Scanners", symbolName: "printer", type: .printers)
            ],
            isGroup: true,
            type: nil
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
        let view = NSVisualEffectView()
        view.material = .sidebar
        self.view = view
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
            if let firstLeaf = firstSelectableNode(), outlineView.row(forItem: firstLeaf) >= 0 {
                outlineView.selectRowIndexes(IndexSet(integer: outlineView.row(forItem: firstLeaf)), byExtendingSelection: false)
            }
        }
    }
    
    private func firstSelectableNode() -> SideBarNode? {
        for note in notes {
            if !note.isGroup { return note }
            if let child = note.children.first, child.type != nil {
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
        guard outlineView.selectedRow >= 0, let node = outlineView.item(atRow: outlineView.selectedRow) as? SideBarNode, let type = node.type else {
            return
        }
        delegate?.sideBar(self, didSelectItem: type)
    }
}
