import UIKit
import RxSwift

/// Nonscrollable stack of buttons.
final class HorizontalButtonStack: UIStackView {

    // MARK: - Constants

    private struct Constants {
        static let spacing: CGFloat = 8
        static let distribution: UIStackView.Distribution = .fillEqually
        static let axis: NSLayoutConstraint.Axis = .vertical
    }

    // MARK: - Public properties

    /// Sends current selected button index. Start value is zero.
    let subject = BehaviorSubject<Int>(value: 0)
    let titles: [String]

    // MARK: - Private properties

    private var selectedButtonIndex: Int = 0
    private var buttons: [ReusableButton] = []

    private lazy var buttonAction: UIAction = UIAction { [weak self] action in
        guard let sender = action.sender as? ReusableButton,
              let currentSelectedButtonIndex = self?.selectedButtonIndex,
              let senderIndex = self?.buttons.firstIndex(of: sender),
              senderIndex != currentSelectedButtonIndex
        else {
            return
        }

        UIView.animate(withDuration: 0.3) {
            self?.buttons[currentSelectedButtonIndex].isOn = false
            sender.isOn = true
        }

        self?.selectedButtonIndex = senderIndex
        // rx
        self?.subject.onNext(senderIndex)
    }

    // MARK: - Initialization

    init(titles: [String]) {
        self.titles = titles
        super.init(frame: .zero)
        
        prepareButtons()
        prepareUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func prepareButtons() {
        buttons = titles.map { title in
            let button = ReusableButton(title: title)
            button.addAction(buttonAction, for: .touchUpInside)
            
            return button
        }

        buttons.first?.isOn = true
    }

    private func prepareUI() {
        axis = Constants.axis
        distribution = Constants.distribution
        spacing = Constants.spacing
        
        buttons.forEach { button in
            addArrangedSubview(button)
        }
    }

}