import UIKit
import SwiftUI

final class GraphViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let suiView = GraphSUIView()
    private lazy var hostingViewController = UIHostingController(rootView: self.suiView)
    
    // MARK: - Life cycle
    
    override func loadView() {
        let view = UIView()
        
        hostingViewController.view?.frame = UIWindow().frame
        view.addSubview(hostingViewController.view)

        self.view = view
    }
    
}
