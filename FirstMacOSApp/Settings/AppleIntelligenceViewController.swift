import Foundation
import Cocoa

final class AppleIntelligenceViewController: NSViewController {
    override func loadView() {
        super.loadView()
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
    }
}
