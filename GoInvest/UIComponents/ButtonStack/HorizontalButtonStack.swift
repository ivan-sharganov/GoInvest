import UIKit
import RxCocoa

/// Nonscrollable stack of buttons.
final class HorizontalButtonStack: UIStackView {

    // MARK: - Constants

    public enum Size {
        case small
        case large
    }
    
    private struct Constants {
        static let spacing: CGFloat = 8
        static let largeFontSize: CGFloat = 38
        static let smallFontSize: CGFloat = 17 
        static let distribution: UIStackView.Distribution = .fillProportionally
        static let axis: NSLayoutConstraint.Axis = .horizontal
    }

    // MARK: - Public properties

    /// Sends current selected button index. Start value is zero.
    var subject: Driver<Int> { _subject.asDriver() }
    private let _subject = BehaviorRelay<Int>(value: 0)
    
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
        self?._subject.accept((senderIndex))
        
    }

    // MARK: - Initialization
    
    init(titles: [String], size: Size) {
        self.titles = titles
        super.init(frame: .zero)
        prepareButtons(size: size)
        prepareUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func prepareButtons(size: Size) {
        buttons = titles.map { title in
            let button: ReusableButton
            switch size {
            case .small:
                button = ReusableButton(
                    title: title,
                    fontSize: Constants.smallFontSize,
                    onBackgroundColor: .onTabBackground,
                    offBackgroundColor: .offTabBackground,
                    onTitleColor: .inversedLabel,
                    offTitleColor: .label
                )
                self.distribution = .fillEqually
                
            case .large:
                button = ReusableButton(
                    title: title,
                    fontSize: Constants.largeFontSize,
                    onBackgroundColor: .background,
                    offBackgroundColor: .background,
                    onTitleColor: .label,
                    offTitleColor: .offLargeTabTitle
                )
                self.distribution = .fillProportionally
            }
            button.addAction(buttonAction, for: .touchUpInside)
            
            return button
        }
        buttons.first?.isOn = true
    }

    private func prepareUI() {
        axis = Constants.axis
        spacing = Constants.spacing
        
        buttons.forEach { button in
            addArrangedSubview(button)
        }
    }
    
    private func prepareSecuritiesSource(value: Int) -> SecuritiesSource? {
        switch value {
        case 0:
            return .apiRequest
        case 1:
            return .favorities
        default:
            return nil
        }
    }
    
    private func prepareStockState(value: Int) -> StockState? {
        switch value {
        case 0:
            return .shares
        case 1:
            return .index
        case 2:
            return .bonds
        default:
            return nil
        }
    }

}
