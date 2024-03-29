import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    override init(nibName: String? = nil, bundle: Bundle? = nil) {
        super.init(nibName: nibName, bundle: bundle)
        self.setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .tint
        imageView.image = UIImage(systemName: "person.crop.circle")
        return imageView
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Петр Иванов"
        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .background
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1234 акций"
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

    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
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
            
            // bottomLabel
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20),
            bottomLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor),
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var config = cell.stocksCellContentViewConfiguration()
        config.shortName = "sdsd"
        config.fullName = "full"
        config.price = 1234
        config.priceChange = 12345678
        config.rate = 5
        cell.contentConfiguration = config
        return cell
    }
    
}
