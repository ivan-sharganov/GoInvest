import UIKit

final class RateLabel: UILabel {
    
    // MARK: - Public properties
    
    /// Честный ноль из математики - красный
    /// Если делим на ноль, то  - пишем 2 минуса и серый
    var rate: Double = 0 {
        didSet {
            switch rate {
            case 0.1...3:
                backgroundColor = .systemRed
            case 3...7:
                backgroundColor = .systemOrange
            case 7...10:
                backgroundColor = .systemGreen
            default:
                backgroundColor = .systemGray3
                rate = 0
            }
            self.text = rate != 0 ? String(format: "%.1f", rate) : "--"
        }
    }

    // MARK: - Life cycle
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        backgroundColor = .systemCyan

        textColor = .white
        font = UIFont.systemFont(ofSize: 22)
        textAlignment = .center

        setupLayer()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    
    private func setupLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.shadowColor = UIColor.secondarySystemBackground.cgColor
        layer.shadowRadius = 10
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 32),
            widthAnchor.constraint(equalToConstant: 56)
        ])
    }
}
