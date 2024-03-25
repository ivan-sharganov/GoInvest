import UIKit
import RxSwift

final class MainViewController: UIViewController {

    typealias DiffableDataSource = UITableViewDiffableDataSource<Int, StockModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, StockModel>

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
        let stack = HorizontalButtonStack(titles: ["Indexes", "Futures", "Currences"])
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
        tblView.dataSource = diffableDataSource
        tblView.delegate = self
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)

        setupBindings()

        // just in purpose to show that horizintalButtonStack works, delete later
        let _ = horizontalButtonStack.subject.subscribe { event in
            // prints current selected button index
            print(event)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        updateSnapshot()
    }

    // MARK: - Private methods

    private func setupBindings() {
        viewModel.cellTapped
            .subscribe(onNext: { [weak self] in
                self?.router.pushNext()
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

//        setupNavigationController()
    }

}

// MARK: - DiffableDataSource

fileprivate extension MainViewController {

    func createDiffableDataSource() -> DiffableDataSource {
        let dataSource = DiffableDataSource(tableView: tblView) { tableView, indexPath, item in

            guard let fullName = item.shortName, 
                    let shortName = item.ticker, 
                    let price = item.close,
                    let priceChange = item.trendclspr
            else {
                return UITableViewCell()
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
            var configuration = cell.stocksCellContentViewConfiguration()
            
            configuration.fullName = fullName
            configuration.shortName = shortName
            configuration.price = price
            configuration.priceChange = priceChange
            configuration.rate = Double.random(in: 0...10)      // TODO: Add actual data
            cell.contentConfiguration = configuration

            return cell
        }

        return dataSource
    }

    func updateSnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.displayItems, toSection: 0)

        diffableDataSource.apply(snapshot)
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