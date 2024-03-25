import UIKit

final class DetailViewController: UIViewController {
    
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
        let addToFavoritesButton = UIImage(named: "addToFavoritesButton")
        let button = UIButton(type: .custom)
        
//        addToFavoritesButton.frame
        button.setImage(addToFavoritesButton, for: .normal)
        button.contentMode = .center
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let rightBarButtonItem = UIBarButtonItem(customView: button)
//        let rightBarButtonItem = UIBarButtonItem(image: addToFavoritesButton, style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        
//        let sdsd = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    // MARK: - Handlers
    
    @objc
    private func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        sender.image = UIImage(named: "inFavoritesButton")?.withRenderingMode(.alwaysOriginal)
    }

}

@propertyWrapper
struct PhoneNumber {
    var wrappedValue: String
    
}
