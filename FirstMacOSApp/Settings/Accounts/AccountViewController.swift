//
//  AccountViewController.swift
//  FirstMacOSApp
//
//  Created by macbook on 3/9/25.
//

import Foundation
import Cocoa
import SnapKit

extension Array where Element: SectionModelType {
    func numberOfItems(in section: Int) -> Int {
        self[section].items.count
    }
    
    subscript(safe indexPath: IndexPath) -> Element.Item? {
        guard indices.contains(indexPath.section),
              self[indexPath.section].items.indices.contains(indexPath.item) else { return nil }
        return self[indexPath.section].items[indexPath.item]
    }
}

protocol SectionModelType {
    associatedtype Item
    var items: [Item] { get }
    init(original: Self, items: [Item])
}

enum AccountSection: SectionModelType {
    init(original: AccountSection, items: [AccountItem]) {
        switch original {
        case .account(let item):
            self = .account(item: item)
        case .personalInfo(let items):
            self = .personalInfo(items: items)
        case .icloud(let items):
            self = .icloud(items: items)
        case .devices(let title, let items):
            self = .devices(title: title, items: items)
        }
    }
    
    var items: [AccountItem] {
        switch self {
        case .account(let item):
            return [item]
        case .personalInfo(let items):
            return items
        case .icloud(let items):
            return items
        case .devices(_, let items):
            return items
        }
    }
    
    case account(item: AccountItem)
    case personalInfo(items: [AccountItem])
    case icloud(items: [AccountItem])
    case devices(title: String, items: [AccountItem])
}

enum AccountItem {
    case account(name: String, email: String)
    case personalInfo(title: String, icon: String)
    case icloud(title: String, subtitle: String?, icon: String)
    case device(device: IcloudDevice)
}

final class AccountViewController: NSViewController {
    private let sections: [AccountSection] = [
        .account(item: .account(name: "thanh tien", email: "")),
        .personalInfo(
            items: [
                .personalInfo(title: "Personal Information", icon: "person.text.rectangle"),
                .personalInfo(title: "Sign-In & Security", icon: "lock.shield"),
                .personalInfo(title: "Payment & Shipping", icon: "creditcard")
            ]
        ),
        .icloud(
            items: [
                .icloud(title: "iCloud", subtitle: nil, icon: "icloud.square.fill"),
                .icloud(title: "Family", subtitle: "Set Up", icon: "figure.2.and.child.holdinghands"),
                .icloud(title: "Media & Purchases", subtitle: nil, icon: "appletv.fill"),
                .icloud(title: "Sign in with Apple", subtitle: nil, icon: "apple.logo")
            ]
        ),
        .devices(
            title: "Devices",
            items: [
                .device(device: IcloudDevice(title: "thanh's Macbook Pro", subtitle: "This Macbook Pro 14'", image: "laptopcomputer")),
                .device(device: IcloudDevice(title: "IT1-699799-2L", subtitle: "Macbook Pro 13'", image: "laptopcomputer")),
                .device(device: IcloudDevice(title: "kennyS", subtitle: "iPhone 13 Pro Max", image: "iphone.gen3")),
                .device(device: IcloudDevice(title: "thanh's iPad", subtitle: "iPad Pro", image: "ipad.gen2")),
                .device(device: IcloudDevice(title: "thanh's Mac Mini", subtitle: "Mac mini", image: "macmini"))
            ]
        )
    ]
    
    private lazy var collectionView: NSCollectionView = {
        let collectionView = NSCollectionView()
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.sectionInset = .init()
        flowLayout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(AccountHeaderView.self, forItemWithIdentifier: .init("AccountHeaderView"))
        collectionView.register(AccountPersonalInfoCell.self, forItemWithIdentifier: .init("AccountPersonalInfoCell"))
        collectionView.register(AccountDevicesCell.self, forItemWithIdentifier: .init("AccountDevicesCell"))
        collectionView.register(AccountFooterView.self, forSupplementaryViewOfKind: NSCollectionView.elementKindSectionFooter, withIdentifier: .init("AccountFooterView"))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColors = [.clear]
        return collectionView
    }()
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.documentView = collectionView
        scrollView.scrollerStyle = .legacy
        scrollView.hasVerticalScroller = true
        scrollView.automaticallyAdjustsContentInsets = false
        return scrollView
    }()
    
    override func loadView() {
        super.loadView()
        let view = NSView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Apple Account"
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.drawsBackground = false
    }
}

extension AccountViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = sections[indexPath.item]
        switch item {
        case .account(let item):
            guard let cell = collectionView.makeItem(withIdentifier: .init("AccountHeaderView"), for: indexPath) as? AccountHeaderView,
                  case let .account(name, email) = item else {
                return NSCollectionViewItem()
            }
            cell.config(name: name, email: email)
            return cell
        case .personalInfo(let items), .icloud(let items):
            guard let cell = collectionView.makeItem(withIdentifier: .init("AccountPersonalInfoCell"), for: indexPath) as? AccountPersonalInfoCell else {
                return NSCollectionViewItem()
            }
            cell.config(items: items)
            return cell
        case let .devices(title, items):
            guard let cell = collectionView.makeItem(withIdentifier: .init("AccountDevicesCell"), for: indexPath) as? AccountDevicesCell else {
                return .init()
            }
            cell.config(title: title, items: items)
            return cell
        }
    }
}

extension AccountViewController: NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        switch sections[indexPath.item] {
        case .account:
            return .init(width: collectionView.frame.width, height: 160)
        case .personalInfo(let items), .icloud(let items):
            return .init(width: collectionView.frame.width, height: CGFloat(40 * items.count) + 16)
        case .devices(_, let items):
            return .init(width: collectionView.frame.width, height: CGFloat(items.count * 60 + 40))
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize {
        return .init(width: collectionView.frame.width, height: 48)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        switch kind {
        case NSCollectionView.elementKindSectionFooter:
            guard let footer = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: .init("AccountFooterView"), for: indexPath) as? AccountFooterView else {
                return NSView()
            }
            footer.delegate = self
            return footer
        default:
            return NSView()
        }
    }
}

extension AccountViewController: AccountFooterDelegate {
    func signoutAction() {
        print("Sign out")
    }
    
    func helpAction() {
        print("Help")
    }
}
