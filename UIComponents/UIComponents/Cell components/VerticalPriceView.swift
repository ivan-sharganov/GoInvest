import UIKit

final class VerticalPriceView: UIView {
    // MARK: - Properties
    /// Current price.
    var price: Double = 0 {
        didSet { priceLabel.text = String(format: "%.2f", price) }
    }
    
    /// Percent price change.
    var priceChange: Double = 0 {
        didSet {
            changeLabel.text = String(format: "%.2f", priceChange) + "%"
            let color: UIColor = priceChange >= 0 ? .systemGreen : .systemRed
            changeLabel.textColor = color
            priceLabel.textColor = color
        }
    }
    
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupViews() {
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.text = "0.0"
        priceLabel.textAlignment = .right
        priceLabel.textColor = .systemGreen
        changeLabel.font = UIFont.systemFont(ofSize: 18)
        changeLabel.text = "0.0%"
        changeLabel.textAlignment = .right
        changeLabel.textColor = .systemGreen
        
        addSubview(priceLabel)
        addSubview(changeLabel)
    }
    
    private func setupConstraints() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 42),
            widthAnchor.constraint(equalToConstant: 72),
            
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 23),
            
            changeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            changeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            changeLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            changeLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
    }
}
