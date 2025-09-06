//
//  SettingsWindowController.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Cocoa
import Foundation

final class SettingsWindowController: NSWindowController {
    private let windowSize = 700.0
    private let sideBarWidth = 220.0
    private let minWindowHeight = 500.0
    private var oldFrame: NSRect = .zero
    
    private let sidebarVC = SidebarViewController()
    private let contentVC = SettingsContentHostViewController()
    
    private var selectedItem: SideBarNodeItemType?
    
    init() {
        let splitVC = NSSplitViewController()
        splitVC.splitView.isVertical = true
        splitVC.splitView.dividerStyle = .thin
        
        let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebarVC)
        sidebarItem.maximumThickness = sideBarWidth
        sidebarItem.minimumThickness = sideBarWidth
        sidebarItem.holdingPriority = .init(999)
        sidebarItem.canCollapse = false
        
        let contentItem = NSSplitViewItem(viewController: contentVC)
        contentItem.maximumThickness = windowSize - sideBarWidth
        contentItem.minimumThickness = windowSize - sideBarWidth
        contentItem.canCollapse = false
        contentItem.holdingPriority = .init(999)
        
        splitVC.addSplitViewItem(sidebarItem)
        splitVC.addSplitViewItem(contentItem)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: windowSize, height: windowSize),
            styleMask: [.titled, .miniaturizable, .resizable, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.minSize.height = minWindowHeight
        window.collectionBehavior.remove(.fullScreenPrimary)
        
        let toolbar = NSToolbar(identifier: "MainToolbar")
        toolbar.showsBaselineSeparator = false
        toolbar.sizeMode = .small
        window.toolbar = toolbar
        window.toolbarStyle = .unified
        window.contentViewController = splitVC
        
        super.init(window: window)
        window.delegate = self
        sidebarVC.delegate = self
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        if let zoomButton = window.standardWindowButton(.zoomButton) {
            zoomButton.target = self
            zoomButton.action = #selector(handleZoom)
        }
        
        oldFrame = window.frame
    }
    
    @objc private func handleZoom() {
        guard let window = window, let visibleFrame = NSScreen.main?.visibleFrame else {
            return
        }
        if window.frame.height == visibleFrame.height, oldFrame != .zero {
            window.setFrame(oldFrame, display: true, animate: true)
        } else {
            oldFrame = window.frame
            window.setFrame(NSRect(x: window.frame.origin.x, y: 0, width: windowSize, height: visibleFrame.height), display: true, animate: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsWindowController: NSWindowDelegate {
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        let screenFrame = sender.screen?.visibleFrame ?? NSScreen.main?.visibleFrame ?? .zero
        
        var newSize = frameSize
        newSize.width = windowSize
        let newHeight = max(minWindowHeight, min(frameSize.height, screenFrame.height))
        newSize.height = newHeight
        return newSize
    }
}

extension SettingsWindowController: SideBarViewControllerDelegate {
    func sideBar(_ vc: SidebarViewController, didSelectItem: SideBarNodeItemType) {
        guard selectedItem != didSelectItem else {
            return
        }
        selectedItem = didSelectItem
        var destination: NSViewController?
        
        switch didSelectItem {
        case .account:
            destination = AccountViewController()
        case .wifi:
            destination = WifiViewController()
        case .bluetooth:
            destination = BluetoothViewController()
        case .network:
            destination = NetworkViewController()
        case .battery:
            destination = BatteryViewController()
        case .general:
            destination = GeneralViewController()
        case .accessibility:
            destination = AccessibilityViewController()
        case .appearance:
            destination = AppearanceViewController()
        case .appleIntelligence:
            destination = AppleIntelligenceViewController()
        case .controlCenter:
            destination = ControlCenterViewController()
        case .desktopDock:
            destination = DesktopDockViewController()
        case .displays:
            destination = DisplayViewController()
        case .screenSaver:
            destination = ScreenSaverViewController()
        case .spotlight:
            destination = SpotlightViewController()
        case .wallpaper:
            destination = WallpaperViewController()
        case .notifications:
            destination = NotificationViewController()
        case .sound:
            destination = SoundViewController()
        case .focus:
            destination = FocusViewController()
        case .lockScreen:
            destination = LockScreenViewController()
        case .privacy:
            destination = PrivacyViewController()
        case .touchId:
            destination = TouchIDViewController()
        case .userGroup:
            destination = UserGroupViewController()
        case .internetAccount:
            destination = InternetAccountViewController()
        case .gameCenter:
            destination = GameCenterViewController()
        case .icloud:
            destination = IcloudViewController()
        case .wallet:
            destination = WalletViewController()
        case .keyboard:
            destination = KeyboardViewController()
        case .trackpad:
            destination = TrackpadViewController()
        case .printers:
            destination = PrinterViewController()
        }
        
        guard let destination = destination else {
            return
        }
        contentVC.show(destination)

    }
}
