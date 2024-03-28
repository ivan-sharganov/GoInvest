import UIKit
import RxSwift

final class MainViewController: UIViewController {

    typealias DiffableDataSource = UITableViewDiffableDataSource<Int, StockDisplayItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, StockDisplayItem>

    // MARK: - Public properties

    // MARK: - Private properties
    
    private var isPressed = false
    private var viewModel: MainViewModel
    private let bag = DisposeBag()
    private lazy var router: MainRoutable = MainRouter(viewController: self)
    private lazy var diffableDataSource = createDiffableDataSource()

    // MARK: - UI

    private lazy var tblView: UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = .background
        tbl.keyboardDismissMode = .onDrag
        tbl.delegate = self

        return tbl
    }()

    private lazy var horizontalButtonStack: HorizontalButtonStack = {
        let stack = HorizontalButtonStack(
            titles: [
                NSLocalizedString("shares", comment: ""),
                NSLocalizedString("indexes", comment: ""),
                NSLocalizedString("bonds", comment: ""),
            ],
            size: .small
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var navItem: HorizontalButtonStack = {
        let stack = HorizontalButtonStack(
            titles: [
                NSLocalizedString("securities", comment: ""),
                NSLocalizedString("favorities", comment: ""),
            ],
            size: .large
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.placeholder = NSLocalizedString("search", comment: "")
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }()
    
    // MARK: - Life cycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        
        setupTabBarItem()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        tblView.dataSource = diffableDataSource
        tblView.delegate = self
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        searchBar.delegate = self
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        updateSnapshot()
    }

    // MARK: - Private methods

    private func setupBindings() {
        horizontalButtonStack.subject
            .drive(onNext: { [weak self] stockState in
                self?.viewModel.chooseStockStateData(stockState: stockState)
            })
//            .subscribe(onNext: { [weak self] stockState in
//                self?.viewModel.chooseStockStateData(stockState: stockState)
//            })
            .disposed(by: bag)
        
        viewModel.cellTapped
            .emit(onNext: { [weak self] securitiesTranferModel in
                self?.router.pushNext(transferModel: securitiesTranferModel)
            })
            .disposed(by: bag)
        
        viewModel.updateSnapshot
            .emit(onNext: { [weak self] result in
                self?.updateSnapshot(animatingDifferences: result)
            })
            .disposed(by: bag)
    }

    private func setupUI() {
        view.addSubview(self.navItem)
        view.addSubview(self.horizontalButtonStack)
        view.addSubview(self.tblView)
        view.addSubview(self.searchBar)

        self.view.backgroundColor = .background
        hideKeyboardWhenTappedAround()
        
        self.tblView.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.navItem.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.navItem.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4),
            self.navItem.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -4),
            
            self.horizontalButtonStack.topAnchor.constraint(equalTo: self.navItem.bottomAnchor, constant: -5),
            self.horizontalButtonStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 14),
            self.horizontalButtonStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -14),
            self.horizontalButtonStack.heightAnchor.constraint(equalToConstant: 36),
            
            self.searchBar.topAnchor.constraint(equalTo: self.horizontalButtonStack.bottomAnchor, constant: 8),
            self.searchBar.heightAnchor.constraint(equalToConstant: 35),
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            self.searchBar.bottomAnchor.constraint(equalTo: self.tblView.topAnchor, constant: -8),

            self.tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tblView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTabBarItem() {
        let imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let imageScale = 1.6
        let imageName = "newspaper"
        
        let inactiveImage = UIImage(systemName: imageName)?
            .withRenderingMode(.alwaysTemplate)
            .withScale(imageScale)
        
        let activeImage = UIImage(systemName: imageName)?
            .withRenderingMode(.alwaysTemplate)
            .withScale(imageScale)
        
        tabBarItem = UITabBarItem(title: nil, image: inactiveImage, tag: 1)
        tabBarItem.selectedImage = activeImage
        tabBarItem.imageInsets = imageInsets
    }
    
}

// MARK: - DiffableDataSource

fileprivate extension MainViewController {

    func createDiffableDataSource() -> DiffableDataSource {
        let dataSource = DiffableDataSource(tableView: tblView) { tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
            var configuration = cell.stocksCellContentViewConfiguration()

            configuration.fullName = item.name
            configuration.shortName = item.shortName
            configuration.price = item.closePrice
            configuration.priceChange = item.priceChange
            configuration.rate = item.rate
            cell.contentConfiguration = configuration

            return cell
        }

        return dataSource
    }

    func updateSnapshot(animatingDifferences: Bool = false) {
        var snapshot = Snapshot()

        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.displayItems, toSection: 0)

        diffableDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleItemSelection(item: viewModel.displayItems[indexPath.row],
                                      stockState: viewModel.stockState)
    }

}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchItems(for: searchBar.searchTextField.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.searchTextField.text = ""
        self.searchBar.showsCancelButton.toggle()
        self.viewModel.searchItems(for: searchBar.searchTextField.text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
}
