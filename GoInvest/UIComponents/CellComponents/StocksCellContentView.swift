import UIKit

final class StocksCellContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        
        var fullName: String = ""
        var shortName: String = ""
        var rate: Double = 0
        var price: Double = 0
        
        /// Percent price change.
        var priceChange: Double = 0

        func makeContentView() -> any UIView & UIContentView {
            return StocksCellContentView(self)
        }

        func updated(for state: any UIConfigurationState) -> StocksCellContentView.Configuration {
            return self
        }
        
    }

    // MARK: - Public properties
    
    var configuration: any UIContentConfiguration {
        didSet {
            configure(with: configuration)
        }
    }
    
    // MARK: - Private properties

    private let rateLabel = RateLabel()
    private let namesView = NamesView()
    private let graph = MockGraph()
    private let priceView = VerticalPriceView()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 64)
    }

    // MARK: - Life cycle
    
    init(_ configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        addSubviews()
        setupConstaits()
        self.backgroundColor = .background
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    
    func configure(with: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        
        rateLabel.rate = configuration.rate
        namesView.shortName = configuration.shortName
        namesView.fullName = configuration.fullName
        priceView.price = configuration.price
        priceView.priceChange = configuration.priceChange
    }
    
    // MARK: - Private methods

    private func addSubviews() {
        addSubview(rateLabel)
        addSubview(namesView)
        addSubview(graph)
        addSubview(priceView)
    }

    private func setupConstaits() {
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        namesView.translatesAutoresizingMaskIntoConstraints = false
        graph.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            rateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            namesView.leadingAnchor.constraint(equalTo: rateLabel.trailingAnchor, constant: 12),
            namesView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            namesView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            graph.leadingAnchor.constraint(equalTo: namesView.trailingAnchor, constant: 14),
            graph.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            graph.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            priceView.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            priceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            priceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
}
