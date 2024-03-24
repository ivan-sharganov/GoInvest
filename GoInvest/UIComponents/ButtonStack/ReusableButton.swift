import UIKit

/// Used in HorizontalButtonStack.
final class ReusableButton: UIButton {

    // MARK: - Public properties

    var isOn: Bool = false {
        didSet {
            backgroundColor = self.isOn ? .systemGray : .systemGray5
            setTitleColor(
                self.isOn ? .white : .black,
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
        backgroundColor = .systemGray5
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

}
