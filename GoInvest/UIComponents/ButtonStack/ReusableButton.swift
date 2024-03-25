import UIKit

/// Used in HorizontalButtonStack.
final class ReusableButton: UIButton {

    // MARK: - Constants

    private struct Constants {
        static let cornerRadius: CGFloat = 10
    }

    // MARK: - Public properties
    private let onBackgroundColor: UIColor
    private let offBackgroundColor: UIColor
    private let onTitleColor: UIColor
    private let offTitleColor: UIColor

    var isOn: Bool = false {
        didSet {
            backgroundColor = self.isOn ?
                self.onBackgroundColor : self.offBackgroundColor
            setTitleColor(
                self.isOn ? self.onTitleColor : self.offTitleColor,
                for: .normal
            )
        }
    }

    // MARK: - Initialization

    init(
        title: String,
        fontSize: CGFloat,
        onBackgroundColor: UIColor,
        offBackgroundColor: UIColor,
        onTitleColor: UIColor,
        offTitleColor: UIColor
    ) {
        self.onBackgroundColor = onBackgroundColor
        self.offBackgroundColor = offBackgroundColor
        self.onTitleColor = onTitleColor
        self.offTitleColor = offTitleColor
        super.init(frame: .zero)
        setTitle(title, for: .normal)

        self.backgroundColor = offBackgroundColor
        self.setTitleColor(offTitleColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupView() {
        
    }

}
