import UIKit

final class RateLabel: UILabel {
    // MARK: - Properties
    var rate: Double = 0 {
        didSet {
            switch rate {
            case 0...3:
                backgroundColor = .systemRed
            case 0...7:
                backgroundColor = .systemOrange
            case 7...10:
                backgroundColor = .systemGreen
            default:
                backgroundColor = .systemGray
                rate = 0
            }
            text = String(format: "%.1f", rate)
        }
    }
    
    // MARK: - Initialization
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
    
    // MARK: - Methods
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
