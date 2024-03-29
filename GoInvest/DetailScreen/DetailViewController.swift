import UIKit
import SwiftUI

final class DetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let suiViewMain = GraphSUIViewMain()
    private let suiViewAdditional = GraphSUIViewMain()
    private var isFavorite: Bool = false
    
    private lazy var hostingMainViewController = UIHostingController(rootView: self.suiViewMain)
    private lazy var hostingAdditionalViewController = UIHostingController(rootView: self.suiViewAdditional)
    private var viewModel: DetailViewModel
    
    // MARK: - UI
    
    private lazy var buyButton: UIButton = {
        let button = ReusableButton(title: NSLocalizedString("buy", comment: ""), fontSize: 17, onBackgroundColor: .buttonBackground, offBackgroundColor: .buttonBackground, onTitleColor: .buttonTitle, offTitleColor: .buttonTitle)
        
        return button
    }()
    
    private lazy var priceView: HorizontalPriceView = {
        let view = HorizontalPriceView()
        
        view.price = viewModel.displayItem.price
        view.priceDifference = viewModel.displayItem.priceChange
        
        return view
    }()
    
    private lazy var rangesHStack: HorizontalButtonStack = {
        let stack = HorizontalButtonStack(
            titles:
                GraphRangeValues.allCases.map {$0.stringValue}
            ,
            size: .small
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var functionsHStack: HorizontalButtonStack = {
        let stack = HorizontalButtonStack(
            titles:
                MathFunctions.allCases.map {$0.rawValue}
            ,
            size: .small
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        print(viewModel.allPoints)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        guard let hostingMainView = hostingMainViewController.view,
              let hostingAdditionalView = hostingAdditionalViewController.view else { return }
        
        self.title = "\(viewModel.displayItem.title) (\(viewModel.displayItem.subtitle))"
        
        hostingMainView.translatesAutoresizingMaskIntoConstraints = false
        hostingAdditionalView.translatesAutoresizingMaskIntoConstraints = false
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = .background
        self.navigationController?.isNavigationBarHidden = false
        
        view.addSubview(hostingMainView)
        view.addSubview(hostingAdditionalView)
        view.addSubview(buyButton)
        view.addSubview(priceView)
        view.addSubview(rangesHStack)
        view.addSubview(functionsHStack)
        self.buyButton.addTarget(nil, action: #selector(tapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.priceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.priceView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            self.rangesHStack.topAnchor.constraint(equalTo: self.priceView.bottomAnchor, constant: 4 ),
            self.rangesHStack.leadingAnchor.constraint(equalTo: self.priceView.leadingAnchor),
            self.rangesHStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.rangesHStack.heightAnchor.constraint(equalToConstant: 36),
            
            hostingMainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            hostingMainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            hostingMainView.topAnchor.constraint(equalTo: self.rangesHStack.bottomAnchor, constant: 8),
            hostingMainView.heightAnchor.constraint(equalToConstant: 250),
            
            hostingAdditionalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            hostingAdditionalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            hostingAdditionalView.topAnchor.constraint(equalTo: hostingMainView.bottomAnchor, constant: 10),
            hostingAdditionalView.heightAnchor.constraint(equalToConstant: 100),
            
            self.functionsHStack.topAnchor.constraint(equalTo: hostingAdditionalView.bottomAnchor, constant: 20),
            self.functionsHStack.leadingAnchor.constraint(equalTo: rangesHStack.leadingAnchor),
            self.functionsHStack.trailingAnchor.constraint(equalTo: rangesHStack.trailingAnchor),
            self.functionsHStack.heightAnchor.constraint(equalTo: rangesHStack.heightAnchor),
            
            self.buyButton.topAnchor.constraint(greaterThanOrEqualTo: functionsHStack.bottomAnchor, constant: -16),
            self.buyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            self.buyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            self.buyButton.heightAnchor.constraint(equalToConstant: 50),
            self.buyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        configureNavigationBar()
    }
    
    @objc private func tapped() {
        Fireworks.fireworks(view: self.tabBarController?.view ?? UIView())
    }
    
    private func configureNavigationBar() {
        let favoritesBarButton = setupFavoriteButton(isFavorite: isFavorite)
        let rightBarButtonItem = UIBarButtonItem(image: favoritesBarButton, style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
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
