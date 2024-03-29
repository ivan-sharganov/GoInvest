import UIKit
import RxSwift
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let loginView = LoginView()
    private let disposeBag = DisposeBag()
    private let loginViewModel: LoginViewModel
    private lazy var router = LoginRouter(loginViewController: self)
    
    // MARK: - Lifecycle
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        loginView.loginButtonTapped.subscribe { [weak self] _ in
            guard let email = self?.loginView.email,
                  let password = self?.loginView.password,
                  let strongSelf = self
            else {
                return
            }
            
            strongSelf.loginViewModel.logIn(email: email, password: password) { _, error in
                if error == nil {
                    self?.router.pushNext()
                } else {
                    debugPrint(error)
                    let alert = UIAlertController(
                        title: NSLocalizedString("Login error", comment: "login failure alert title"),
                        message: error?.localizedDescription,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "login failure alert button title"), style: .cancel))
                    strongSelf.present(alert, animated: true)
                }
            }
        }.disposed(by: disposeBag)
        
        loginView.createAccountButtonTapped.subscribe { [weak self] _ in
            guard let email = self?.loginView.email,
                  let password = self?.loginView.password,
                  let strongSelf = self
            else {
                return
            }
            
            strongSelf.loginViewModel.createAccount(email: email, password: password) { _, error in
                if error == nil, FirebaseAuth.Auth.auth().currentUser != nil {
                    self?.router.pushNext()
                } else {
                    debugPrint(error)
                    let alert = UIAlertController(
                        title: NSLocalizedString("Account creation error", comment: "Account creation failure alert title"),
                        message: error?.localizedDescription,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Account creation failure alert button title"), style: .cancel))
                    strongSelf.present(alert, animated: true)
                }
            }
        }.disposed(by: disposeBag)
    }
}
