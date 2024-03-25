import UIKit

/// Used in HorizontalButtonStack.
final class ReusableButton: UIButton {

    // MARK: - Constants

    private struct Constants {
        static let font: UIFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let onBackgroundColor: UIColor = .systemGray
        static let offBackgroundColor: UIColor = .systemGray5
        static let onTitleColor: UIColor = .white
        static let offTitleColor: UIColor = .black
        static let cornerRadius: CGFloat = 10
    }

    // MARK: - Public properties

    var isOn: Bool = false {
        didSet {
            backgroundColor = self.isOn ?
                Constants.onBackgroundColor : Constants.offBackgroundColor
            setTitleColor(
                self.isOn ? Constants.onTitleColor : Constants.offTitleColor,
                for: .normal
            )
        }
    }

    // MARK: - Initialization

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = Constants.offBackgroundColor
        setTitleColor(Constants.offTitleColor, for: .normal)
        titleLabel?.font = Constants.font
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }

}
