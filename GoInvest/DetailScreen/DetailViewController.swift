import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var isFavorite: Bool = false
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let favoritesBarButton = setupFavoriteButton(isFavorite: isFavorite)
        let rightBarButtonItem = UIBarButtonItem(image: favoritesBarButton, style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        let backBarButtonItem = UIBarButtonItem()
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupFavoriteButton(isFavorite: Bool) -> UIImage? {
        if isFavorite {
            return UIImage(systemName: "heart.fill")
        }
        
        return UIImage(systemName: "heart")
    }
    
    // MARK: - Handlers
    
    @objc
    private func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        isFavorite = !isFavorite
        sender.image = setupFavoriteButton(isFavorite: isFavorite)
    }

}