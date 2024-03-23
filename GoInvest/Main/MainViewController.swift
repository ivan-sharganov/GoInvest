import UIKit

final class MainViewController: UIViewController {

    typealias DiffableDataSource = UITableViewDiffableDataSource<Int, StockModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, StockModel>

    // MARK: - Public properties

    // MARK: - Private properties

    private var viewModel: MainViewModel
    private lazy var diffableDataSource = createDiffableDataSource()

    // MARK: - UI

    private lazy var tblView: UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = .red
        tbl.translatesAutoresizingMaskIntoConstraints = false

        return tbl
    }()

    private lazy var segmentedController: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Индексы", "Фьючерсы", "Валюты"])
        control.backgroundColor = .systemGray6
        control.selectedSegmentTintColor = .gray
        control.translatesAutoresizingMaskIntoConstraints = false

        return control
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
    }

    override func viewWillAppear(_ animated: Bool) {
        updateSnapshot()
    }

    private func setupUI() {
        view.addSubview(self.tblView)
        view.addSubview(self.segmentedController)

        NSLayoutConstraint.activate([
            self.segmentedController.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.segmentedController.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.segmentedController.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.segmentedController.bottomAnchor.constraint(equalTo: self.tblView.topAnchor),
            self.segmentedController.heightAnchor.constraint(equalToConstant: 35),

//            tblView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            self.tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tblView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

// MARK: - DiffableDataSource

fileprivate extension MainViewController {

    func createDiffableDataSource() -> DiffableDataSource {
        let dataSource = DiffableDataSource(tableView: tblView) { [weak self] _, _, displayItems in
            self?.setupCell(text: displayItems.shortName ?? "nil") ?? UITableViewCell()
        }

        return dataSource
    }

    func updateSnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.displayItems, toSection: 0)

        diffableDataSource.apply(snapshot)
    }

    func setupCell(text: String) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.textLabel?.text = text

        return cell
    }

}
