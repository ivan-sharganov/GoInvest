import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var suiViewMain: GraphSUIViewMain = {
        GraphSUIViewMain(pointsData: viewModel.allPoints.points, agregatedPointsData: viewModel.allPoints.points)
    }()
    private lazy var suiViewAdditional: GraphSUIViewMain = {
        GraphSUIViewMain(pointsData: viewModel.allPoints.points, agregatedPointsData: viewModel.allPoints.points)
    }()
    private var isFavorite: Bool = false // MARK: - TODO: УДАЛИТЬ КОГДА МОДУЛЬ БУДЕТ
    
    private lazy var hostingMainViewController = UIHostingController(rootView: self.suiViewMain)
    private lazy var hostingAdditionalViewController = UIHostingController(rootView: self.suiViewAdditional)

    private lazy var proxyView = UIView()
    private var viewModel: DetailViewModel

    private var stockDisplayItem: StockDisplayItem

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
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.displayItem.title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        
        return label
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
    
    init(viewModel: DetailViewModel, stocksDisplayItem: StockDisplayItem) {
        self.viewModel = viewModel

        self.stockDisplayItem = stocksDisplayItem

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
        
        guard let hostingMainView = hostingMainViewController.view,
              let hostingAdditionalView = hostingAdditionalViewController.view else { return }
        
        hostingMainViewController.view.backgroundColor = .background
        hostingAdditionalViewController.view.backgroundColor = .background
        print(viewModel.allPoints)
        
        hostingMainView.translatesAutoresizingMaskIntoConstraints = false
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = .background
        self.navigationController?.isNavigationBarHidden = false
        
        view.addSubview(buyButton)
        view.addSubview(priceView)
        view.addSubview(nameLabel)
        view.addSubview(rangesHStack)
        view.addSubview(functionsHStack)
        view.addSubview(proxyView)
        proxyView.addSubview(hostingMainView)
        proxyView.translatesAutoresizingMaskIntoConstraints = false
        self.buyButton.addTarget(nil, action: #selector(tapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 4),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            
            self.priceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.priceView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            self.rangesHStack.topAnchor.constraint(equalTo: self.priceView.bottomAnchor, constant: 8),
            self.rangesHStack.leadingAnchor.constraint(equalTo: self.priceView.leadingAnchor),
            self.rangesHStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.rangesHStack.heightAnchor.constraint(equalToConstant: 36),
            
//            hostingAdditionalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
//            hostingAdditionalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
//            hostingAdditionalView.topAnchor.constraint(equalTo: hostingMainView.bottomAnchor, constant: 10),
//            hostingAdditionalView.heightAnchor.constraint(equalToConstant: 100),
            
            self.functionsHStack.topAnchor.constraint(equalTo: hostingMainView.bottomAnchor, constant: 20),
            self.functionsHStack.leadingAnchor.constraint(equalTo: rangesHStack.leadingAnchor),
            self.functionsHStack.trailingAnchor.constraint(equalTo: rangesHStack.trailingAnchor),
            self.functionsHStack.heightAnchor.constraint(equalTo: rangesHStack.heightAnchor),
            
            self.buyButton.topAnchor.constraint(greaterThanOrEqualTo: functionsHStack.bottomAnchor, constant: -16),
            self.buyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 13),
            self.buyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -13),
            self.buyButton.heightAnchor.constraint(equalToConstant: 50),
            self.buyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            proxyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            proxyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            proxyView.topAnchor.constraint(equalTo: self.rangesHStack.bottomAnchor, constant: 4),
            proxyView.heightAnchor.constraint(equalToConstant: 300),
            
            hostingMainView.leadingAnchor.constraint(equalTo: self.proxyView.leadingAnchor, constant: 10),
            hostingMainView.trailingAnchor.constraint(equalTo: self.proxyView.trailingAnchor, constant: -10),
            hostingMainView.topAnchor.constraint(equalTo: self.proxyView.topAnchor, constant: 45),
            hostingMainView.heightAnchor.constraint(equalToConstant: 300),

        ])
        
        // Thread 1: "Unable to activate constraint with anchors <NSLayoutYAxisAnchor:0x6000017d6c40 \"GoInvest.HorizontalButtonStack:0x1225bf130.top\"> and <NSLayoutYAxisAnchor:0x6000017d6c80 \"_TtGC7SwiftUI14_UIHostingViewV8GoInvest16GraphSUIViewMain_:0x120e20e40.bottom\"> because they have no common ancestor.  Does the constraint or its anchors reference items in different view hierarchies?  That's illegal."
        
        configureNavigationBar()
    }
    
    @objc private func tapped() {
        Fireworks.fireworks(view: self.tabBarController?.view ?? UIView())
        buyButton.backgroundColor = .systemGray2
        buyButton.isEnabled = false
        
        FirebaseManager.shared.addItems([stockDisplayItem], kind: .bought)
    }
    
    private func configureNavigationBar() {
        let favoritesBarButton = setupFavoriteButton(isFavorite: isFavorite)
        let rightBarButtonItem = UIBarButtonItem(image: favoritesBarButton, style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        self.title = viewModel.displayItem.subtitle
    }
    
    private func setupFavoriteButton(isFavorite: Bool) -> UIImage? {
        isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    // MARK: - Handlers
    
    @objc
    private func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        isFavorite = !isFavorite
        sender.image = setupFavoriteButton(isFavorite: isFavorite)
        
        stockDisplayItem.isFavorite = isFavorite
        
        FirebaseManager.shared.addItems([stockDisplayItem], kind: .favorite)
    }

}
