import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var loginButtonAction: UIAction = UIAction { [weak self] _ in
        guard let email = self?.emailField.text,
              let password = self?.passwordField.text
        else {
            return
        }
        
        // vargunin.iv@gmail.com
        
        FirebaseAuth.Auth.auth().signIn(
            withEmail: email,
            password: password, 
            completion: { _, error in
                
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                
                UserDefaults.standard.setValue(credential, forKey: "user_credential")
                
                if error == nil {
                    print("auth success!!!")
                } else {
                    print("auth failure!!!")
                }
            }
        )
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
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    private let passwordField: TextField = {
        let placeholder = NSLocalizedString(
            "Password",
            comment: "Login password field placeholder text"
        )
        let field = TextField(placeholder: placeholder, isSecure: true)
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
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitle(NSLocalizedString("Create account", comment: "Create account button title text"), for: .normal)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setupSubviews()
        setupContraints()
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
            
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.widthAnchor.constraint(equalToConstant: 300),
            emailField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 36),
            
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalToConstant: 300),
            createAccountButton.heightAnchor.constraint(equalToConstant: 48),
            createAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
        ])
    }
    
}
