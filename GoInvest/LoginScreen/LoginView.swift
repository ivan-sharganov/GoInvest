import UIKit
import RxCocoa

final class LoginView: UIView {
    
    // MARK: - Public properties
    
    let loginButtonTapped = PublishRelay<Void>()
    let createAccountButtonTapped = PublishRelay<Void>()
    var email: String? {
        emailField.text
    }
    var password: String? {
        passwordField.text
    }
    
    // MARK: - Private properties
    
    private lazy var loginButtonAction = UIAction { [weak self] _ in
        self?.loginButtonTapped.accept(())
    }
    
    private lazy var createAccountButtonAction = UIAction { [weak self] _ in
        self?.createAccountButtonTapped.accept(())
    }
    
    // MARK: - UI
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Login", comment: "Login label text")
        label.font = UIFont.systemFont(ofSize: 48, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let emailField: TextField = {
        let placeholder = NSLocalizedString(
            "Email",
            comment: "Login email field placeholder text"
        )
        let field = TextField(placeholder: placeholder, isSecure: false)
        field.backgroundColor = .systemGray5
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    private let passwordField: TextField = {
        let placeholder = NSLocalizedString(
            "Password",
            comment: "Login password field placeholder text"
        )
        let field = TextField(placeholder: placeholder, isSecure: true)
        field.backgroundColor = .systemGray5
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitle(NSLocalizedString("Login", comment: "Login button title text"), for: .normal)
        button.backgroundColor = .buttonBackground
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(loginButtonAction, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitle(NSLocalizedString("Create account", comment: "Create account button title text"), for: .normal)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(createAccountButtonAction, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .background
        
        setupSubviews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        addSubview(label)
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(loginButton)
        addSubview(createAccountButton)
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.widthAnchor.constraint(equalToConstant: 300),
            emailField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 36),
            
            passwordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            
            createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalToConstant: 300),
            createAccountButton.heightAnchor.constraint(equalToConstant: 48),
            createAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
        ])
    }
    
}
