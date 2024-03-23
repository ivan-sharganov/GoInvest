import UIKit

final class NamesView: UIView {

    // MARK: - Properties
    /// Company names that longer than 11 symbols will be cropped.
    var shortName: String? {
        get { shortNameLabel.text }
        set { shortNameLabel.text = newValue }
    }

    /// Company names that longer than 11 symbols will be cropped.
    var fullName: String? {
        get { fullNameLabel.text }
        set { fullNameLabel.text = newValue }
    }

    private let shortNameLabel = UILabel()
    private let fullNameLabel = UILabel()

    // MARK: - Initialization
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setupViews() {
        shortNameLabel.font = UIFont.systemFont(ofSize: 24)
        shortNameLabel.textAlignment = .left
        fullNameLabel.font = UIFont.systemFont(ofSize: 18)
        fullNameLabel.textAlignment = .left

        addSubview(shortNameLabel)
        addSubview(fullNameLabel)
    }

    private func setupConstraints() {
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shortNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),
            widthAnchor.constraint(equalToConstant: 104),

            shortNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            shortNameLabel.topAnchor.constraint(equalTo: topAnchor),
            shortNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            shortNameLabel.heightAnchor.constraint(equalToConstant: 31),

            fullNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            fullNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
    }
}
