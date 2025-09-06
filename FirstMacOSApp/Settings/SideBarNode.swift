//
//  SideBarNode.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Foundation

enum SideBarNodeItemType: CaseIterable, Hashable {
    case account
    case wifi, bluetooth, network, battery
    case general, accessibility, appearance, appleIntelligence, controlCenter
    case desktopDock, displays, screenSaver, spotlight, wallpaper
    case notifications, sound, focus
    case lockScreen, privacy, touchId, userGroup
    case internetAccount, gameCenter, icloud, wallet
    case keyboard, trackpad, printers
}

struct SideBarNode: Hashable {
    let title: String
    let subtitle: String?
    let symbolName: String?
    let children: [SideBarNode]
    let isGroup: Bool
    let type: SideBarNodeItemType?
    
    init(title: String, subtitle: String? = nil, symbolName: String? = nil, children: [SideBarNode] = [], isGroup: Bool = false, type: SideBarNodeItemType?) {
        self.title = title
        self.subtitle = subtitle
        self.symbolName = symbolName
        self.children = children
        self.isGroup = isGroup
        self.type = type
    }
    
    static let account = SideBarNode(
        title: "Thanh tien",
        subtitle: "Apple Account",
        symbolName: "person.crop.circle",
        type: .account
    )
}
