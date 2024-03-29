import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var suiViewAdditional: GraphSUIViewMain = {
        GraphSUIViewMain(pointsData: viewModel.allPoints.points, agregatedPointsData: viewModel.allPoints.points)
    }()
    private var isFavorite: Bool = false // MARK: - TODO: УДАЛИТЬ КОГДА МОДУЛЬ БУДЕТ
    
    private lazy var hostingMainViewController = UIHostingController(rootView: self.suiViewAdditional)
    private lazy var proxyView = UIView()
    private var viewModel: DetailViewModel
    private let bag = DisposeBag()
    
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
    
    // MARK: - Life cycle
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        self.setupUI()

    }
    
    // MARK: - Private methods
    
    private func setupBindings() {
        viewModel.didFetchPoints
        // TODO: точки передать?
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                sleep(1)
                self.hostingMainViewController.view.removeFromSuperview()
                self.hostingMainViewController = UIHostingController(rootView: GraphSUIViewMain(pointsData: viewModel.allPoints.points, agregatedPointsData: MathManager.sma(points: viewModel.allPoints.points)))
                self.view.addSubview(self.hostingMainViewController.view)
                self.setupUI()
                viewModel.allPoints.points.forEach {
                    print($0.y)
                }
            })
            .disposed(by: bag)
    }
    
    private func setupUI() {
        guard let hostingMainView = hostingMainViewController.view else { return }
        
        self.title = "\(viewModel.displayItem.title) (\(viewModel.displayItem.subtitle))"
        
        print(viewModel.allPoints)
        
        hostingMainView.translatesAutoresizingMaskIntoConstraints = false
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = .background
        self.navigationController?.isNavigationBarHidden = false
        
        view.addSubview(hostingMainView)
        view.addSubview(buyButton)
        view.addSubview(priceView)
        view.addSubview(proxyView)
        proxyView.addSubview(hostingMainView)
        proxyView.translatesAutoresizingMaskIntoConstraints = false
        self.buyButton.addTarget(nil, action: #selector(tapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.priceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.priceView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            self.buyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            self.buyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            self.buyButton.heightAnchor.constraint(equalToConstant: 50),
            self.buyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            proxyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            proxyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            proxyView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 45),
            proxyView.heightAnchor.constraint(equalToConstant: 250),
            
            hostingMainView.leadingAnchor.constraint(equalTo: self.proxyView.leadingAnchor, constant: 10),
            hostingMainView.trailingAnchor.constraint(equalTo: self.proxyView.trailingAnchor, constant: -10),
            hostingMainView.topAnchor.constraint(equalTo: self.proxyView.safeAreaLayoutGuide.topAnchor, constant: 45),
            hostingMainView.heightAnchor.constraint(equalToConstant: 250),
            
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
