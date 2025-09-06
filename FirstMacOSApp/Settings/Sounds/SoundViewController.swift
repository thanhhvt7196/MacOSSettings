import Foundation
import Cocoa

final class SoundViewController: NSViewController {
    private lazy var soundEffectsSectionView = SoundEffectsSectionView()

    private lazy var docView: FlippedView = {
        let docView = FlippedView()
        return docView
    }()
    
    let scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.scrollerStyle = .overlay
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.drawsBackground = false
        return scrollView
    }()
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .width
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
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
        title = "Sound"
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.documentView = docView
        docView.addSubview(stackView)
        docView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(scrollView.contentView)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(soundEffectsSectionView)
        soundEffectsSectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
