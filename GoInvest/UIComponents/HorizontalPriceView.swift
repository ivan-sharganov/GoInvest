import UIKit

enum Currence: String {
    
    case rub = "₽"
    case usd = "$"
    case eur = "€"
    
}

final class HorizontalPriceView: UIView {
    
    // MARK: - Public properties
    
    var currence: Currence = .rub
    
    /// Current price.
    var price: Double = 0 {
        didSet { priceLabel.text = currence.rawValue + String(format: "%.2f", price) }
    }

    /// Price difference expressed in money value (not percent).
    var priceDifference: Double = 0 {
        didSet {
            var differenceString = priceDifference >= 0 ? "+" : ""
            differenceString += String(format: "%.2f", priceDifference)
            differenceString += " (" + String(format: "%.2f", differencePercentage) + "%)"
            priceDifferenceLabel.text = differenceString
            priceDifferenceLabel.textColor = priceDifference >= 0 ? .systemGreen : .systemRed
        }
    }
    
    // MARK: - Private properties
    
    private let priceLabel = UILabel()
    private let priceDifferenceLabel = UILabel()
    
    private var differencePercentage: Double {
        let previousPrice = price - priceDifference
        return priceDifference / previousPrice * 100
    }

    // MARK: - Life cycle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods

    private func setupView() {
        priceLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        priceLabel.text = currence.rawValue + "0.00"
        priceDifferenceLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        priceDifferenceLabel.text = "+0.00 (0.00%)"
        priceDifferenceLabel.textColor = .systemGreen

        addSubview(priceLabel)
        addSubview(priceDifferenceLabel)
    }

    private func setupConstraints() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceDifferenceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 27),

            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            priceDifferenceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
            priceDifferenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceDifferenceLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
