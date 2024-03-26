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
        let imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let imageScale = 1.6
        let imageName = "case"

        let inactiveImage = UIImage(systemName: imageName)?
            .withRenderingMode(.alwaysTemplate)
            .withScale(imageScale)

        let activeImage = UIImage(systemName: imageName)?
            .withRenderingMode(.alwaysTemplate)
            .withScale(imageScale)

        tabBarItem = UITabBarItem(title: nil, image: inactiveImage, tag: 2)
        tabBarItem.selectedImage = activeImage
        tabBarItem.imageInsets = imageInsets
    }
    
}
