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
        tbl.backgroundColor = .background
        tbl.backgroundColor = .red
        tbl.keyboardDismissMode = .onDrag
        tbl.translatesAutoresizingMaskIntoConstraints = false

        return tbl
    }()

    private lazy var segmentedController: GISegmentedControl = {
        let control = GISegmentedControl(items: ["Индексы", "Фьючерсы", "Валюты"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = ""
        searchBar.showsCancelButton = true
        searchBar.backgroundColor = .background
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        return searchBar
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
        searchBar.delegate = self
        tblView.dataSource = diffableDataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        updateSnapshot()
    }

    private func setupUI() {
        view.addSubview(self.tblView)
        view.addSubview(self.segmentedController)
        view.addSubview(self.searchBar)
        self.view.backgroundColor = .background
        self.hideKeyboardWhenTappedAround()

        NSLayoutConstraint.activate([
            self.segmentedController.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.segmentedController.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.segmentedController.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.segmentedController.heightAnchor.constraint(equalToConstant: 35),

            self.searchBar.topAnchor.constraint(equalTo: self.segmentedController.bottomAnchor, constant: 8),
            self.searchBar.heightAnchor.constraint(equalToConstant: 35),
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),

            self.tblView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
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
        cell.backgroundColor = .background

        cell.textLabel?.text = text

        return cell
    }

}

// MARK: - SearchBar
extension MainViewController: UISearchBarDelegate {
    /// Обработка кнопки нажатия - поиск в клавиатуре
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)

    }
}