import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var isFavorite: Bool = false
    
    // MARK: - UI
    private lazy var buyButton: UIButton = {
        let button = ReusableButton(title: NSLocalizedString("buy", comment: ""), fontSize: 17, onBackgroundColor: .buttonBackground, offBackgroundColor: .buttonBackground, onTitleColor: .buttonTitle, offTitleColor: .buttonTitle)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .background
        self.navigationController?.isNavigationBarHidden = false
        view.addSubview(buyButton)
        
        NSLayoutConstraint.activate([
            self.buyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 45),
            self.buyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -45),
            self.buyButton.heightAnchor.constraint(equalToConstant: 50),
            self.buyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
        ])
        
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
