import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Life cycle
    
    override init(nibName: String? = nil, bundle: Bundle? = nil) {
        super.init(nibName: nibName, bundle: bundle)
        
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
    }
    
    // MARK: - Private methods
    
    private func setupTabBarItem() {
        let imageSize = CGSize(width: 29, height: 27)
        let imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)

        let image = UIImage(named: "case")?
            .withSize(imageSize)
        let selectedImage = UIImage(named: "case.selected")?
            .withSize(imageSize)

        tabBarItem = UITabBarItem(title: nil, image: image, tag: 2)
        tabBarItem.selectedImage = selectedImage
        tabBarItem.imageInsets = imageInsets
    }
    
}
