import UIKit
import RxSwift

final class MainViewController: UIViewController {

    typealias DiffableDataSource = UITableViewDiffableDataSource<Int, StockDisplayItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, StockDisplayItem>

    // MARK: - Public properties

    // MARK: - Private properties

    private var viewModel: MainViewModel
    private let bag = DisposeBag()
    private lazy var router: Routable = MainRouter(viewController: self)
    private lazy var diffableDataSource = createDiffableDataSource()

    // MARK: - UI

    private lazy var tblView: UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = .background
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.delegate = self

        return tbl
    }()

    private lazy var horizontalButtonStack: HorizontalButtonStack = {
        let stack = HorizontalButtonStack(titles: ["Indexes", "Shares", "Bonds"])
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()

    // MARK: - Life cycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTabBarItem()
        
        tblView.dataSource = diffableDataSource
        tblView.delegate = self
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateSnapshot()
    }

    // MARK: - Private methods

    private func setupBindings() {
        horizontalButtonStack.subject
            .subscribe(onNext: { [weak self] stockState in
                self?.viewModel.chooseStockStateData(stockState: stockState)
            })
            .disposed(by: bag)
        
        viewModel.cellTapped
            .subscribe(onNext: { [weak self] in
                self?.router.pushNext()
            })
            .disposed(by: bag)
        
        viewModel.updateSnapshot
            .subscribe(onNext: { [weak self] result in
                self?.updateSnapshot(animatingDifferences: result)
            })
            .disposed(by: bag)
    }

    private func setupUI() {
        view.addSubview(self.tblView)
        view.addSubview(self.horizontalButtonStack)
        self.view.backgroundColor = .background

        NSLayoutConstraint.activate([
            self.horizontalButtonStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.horizontalButtonStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.horizontalButtonStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.horizontalButtonStack.bottomAnchor.constraint(equalTo: self.tblView.topAnchor, constant: -8),
            self.horizontalButtonStack.heightAnchor.constraint(equalToConstant: 36),

            self.tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tblView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTabBarItem() {
        let imageSize = CGSize(width: 29, height: 22)
        let imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)

        let image = UIImage(named: "list.bullet")?
            .withSize(imageSize)
        let selectedImage = UIImage(named: "list.bullet.selected")?
            .withSize(imageSize)

        tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
        tabBarItem.selectedImage = selectedImage
        tabBarItem.imageInsets = imageInsets
    }

}

// MARK: - DiffableDataSource

fileprivate extension MainViewController {

    func createDiffableDataSource() -> DiffableDataSource {
        let dataSource = DiffableDataSource(tableView: tblView) { tableView, indexPath, item in
            
            guard let fullName = item.name,
                  let shortName = item.shortName,
                  let price = item.closePrice,
                  let priceChange = Optional(Double(52.2)),
                  let rate = item.rate
            else {
                return UITableViewCell()
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
            var configuration = cell.stocksCellContentViewConfiguration()

            configuration.fullName = fullName
            configuration.shortName = shortName
            configuration.price = price
            configuration.priceChange = priceChange
            configuration.rate = rate
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
        viewModel.handleItemSelection()
    }

}
