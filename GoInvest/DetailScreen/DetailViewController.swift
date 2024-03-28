import UIKit
import SwiftUI

final class DetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let suiViewMain = GraphSUIViewMain()
    private let suiViewAdditional = GraphSUIViewMain()
    private var isFavorite: Bool = false // MARK: - TODO: УДАЛИТЬ КОГДА МОДУЛЬ БУДЕТ
    
    private lazy var hostingMainViewController = UIHostingController(rootView: self.suiViewMain)
    private lazy var hostingAdditionalViewController = UIHostingController(rootView: self.suiViewAdditional)
    private var viewModel: DetailViewModel
    
    // MARK: - UI
    
    private lazy var buyButton: UIButton = {
        let button = ReusableButton(title: NSLocalizedString("buy", comment: ""), fontSize: 17, onBackgroundColor: .buttonBackground, offBackgroundColor: .buttonBackground, onTitleColor: .buttonTitle, offTitleColor: .buttonTitle)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var priceView: HorizontalPriceView = {
        let view = HorizontalPriceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        guard let hostingMainView = hostingMainViewController.view,
              let hostingAdditionalView = hostingAdditionalViewController.view else { return }
        
        hostingMainView.translatesAutoresizingMaskIntoConstraints = false
        hostingAdditionalView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .background
        self.navigationController?.isNavigationBarHidden = false
        
        view.addSubview(hostingMainView)
        view.addSubview(hostingAdditionalView)
        view.addSubview(buyButton)
        view.addSubview(priceView)
        self.buyButton.addTarget(nil, action: #selector(tapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.priceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.priceView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            self.buyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            self.buyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            self.buyButton.heightAnchor.constraint(equalToConstant: 50),
            self.buyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            hostingMainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            hostingMainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            hostingMainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 45),
            hostingMainView.heightAnchor.constraint(equalToConstant: 250),
            
            hostingAdditionalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            hostingAdditionalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            hostingAdditionalView.topAnchor.constraint(equalTo: hostingMainView.bottomAnchor, constant: 10),
            hostingAdditionalView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        configureNavigationBar()
    }
    private func firework() {
        let array = [backgroundConfettiLayer(view: self.view), createConfettiLayer(view: self.view)]
        for layer in array {
            view.layer.addSublayer(layer)
            addBehaviors(to: layer)
            addAnimations(to: layer)
        }
    }
    
    @objc private func tapped() {
        self.firework()
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
