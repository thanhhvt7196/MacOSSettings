//
//  SideBarNode.swift
//  FirstMacOSApp
//
//  Created by macbook on 2/9/25.
//

import Foundation

struct SideBarNode: Hashable {
    let title: String
    let subtitle: String?
    let symbolName: String?
    let children: [SideBarNode]
    let isGroup: Bool
    
    init(title: String, subtitle: String? = nil, symbolName: String? = nil, children: [SideBarNode] = [], isGroup: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.symbolName = symbolName
        self.children = children
        self.isGroup = isGroup
    }
    
    static let account = SideBarNode(
        title: "Thanh tien",
        subtitle: "Apple Account",
        symbolName: "person.crop.circle"
    )
}
