import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var items: [StockDisplayItem] = [] {
        didSet {
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - Properties
    
    override init(nibName: String? = nil, bundle: Bundle? = nil) {
        super.init(nibName: nibName, bundle: bundle)
        self.setupTabBarItem()
        
        Task {
            await fetchData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .tint
        imageView.image = .iterator
        return imageView
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = FirebaseAuth.Auth.auth().currentUser?.email
        label.font = UIFont.systemFont(ofSize: 28)
        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .background
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .background
        // Настройте таблицу
        return tableView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.view.backgroundColor = .background
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderWidth = 5
        self.imageView.layer.borderColor = UIColor.inactiveLabel.cgColor
    }
    
    public func fetchData() async {
        FirebaseManager.shared.getItems(
            kind: .bought,
            completition: { result in
                switch result {
                case .success(let items):
                    self.items = items
                case .failure(let error):
                    debugPrint(error)
                }
            }
        )
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(topLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // imageView
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // topLabel
            topLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func setupTabBarItem() {
        let imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let imageScale = 1.6
        let imageName = "person.crop.circle"
        
        let inactiveImage = UIImage(systemName: imageName)?
            .withRenderingMode(.alwaysTemplate)
            .withScale(imageScale)
        
        let activeImage = UIImage(systemName: imageName)?
            .withRenderingMode(.alwaysTemplate)
            .withScale(imageScale)
        
        tabBarItem = UITabBarItem(title: nil, image: inactiveImage, tag: 2)
        tabBarItem.selectedImage = activeImage
        tabBarItem.imageInsets = imageInsets
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        
        let cell = UITableViewCell()
        var configuration = cell.stocksCellContentViewConfiguration()
        configuration.fullName = item.name
        configuration.shortName = item.shortName
        configuration.price = item.closePrice
        configuration.priceChange = item.priceChange
        configuration.rate = item.rate
        cell.contentConfiguration = configuration
        return cell
    }
    
}
