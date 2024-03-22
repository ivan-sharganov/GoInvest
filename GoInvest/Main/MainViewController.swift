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
        
        return tbl
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
        view.addSubview(tblView)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tblView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tblView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

// MARK: - DiffableDataSource

fileprivate extension MainViewController {
    
    func createDiffableDataSource() -> DiffableDataSource {
        let dataSource                                = DiffableDataSource(tableView: tblView) { [weak self] tableView, indexPath, displayItems in
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
