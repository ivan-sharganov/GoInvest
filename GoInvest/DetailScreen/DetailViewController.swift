import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var isFavorite: Bool = false
    
    // MARK: - UI
    
    private let graphViewController = GraphViewController()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        graphViewController.view.frame = CGRect(
            x: 0,
            y: -90,
            width: self.view.frame.width,
            height: 345
        )
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .background
        self.navigationController?.isNavigationBarHidden = false
        
        addChild(graphViewController)
        view.addSubview(graphViewController.view)
        graphViewController.didMove(toParent: self)
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let favoritesBarButton = setupFavoriteButton(isFavorite: isFavorite)
        let rightBarButtonItem = UIBarButtonItem(image: favoritesBarButton, style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupFavoriteButton(isFavorite: Bool) -> UIImage? {
        isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    // MARK: - Handlers
    
    @objc
    private func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        isFavorite = !isFavorite
        sender.image = setupFavoriteButton(isFavorite: isFavorite)
    }

}
