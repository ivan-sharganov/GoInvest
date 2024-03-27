import UIKit
import RxSwift

final class LoginViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let loginView = LoginView()
    private let disposeBag = DisposeBag()
    private let loginViewModel: LoginViewModel
    
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
            
            let isSuccesfulLogin = strongSelf.loginViewModel.logIn(email: email, password: password)
            
            if !isSuccesfulLogin {
                // написать, что не получилось, предложить сделать еще раз
            }
        }.disposed(by: disposeBag)
        
        loginView.createAccountButtonTapped.subscribe { [weak self] _ in
            guard let email = self?.loginView.email,
                  let password = self?.loginView.password,
                  let strongSelf = self
            else {
                return
            }
            
            let isSuccessfulCreateAccount = strongSelf.loginViewModel.createAccount(email: email, password: password)
            
            if isSuccessfulCreateAccount {
                // ...
            } else {
                // ...
            }
        }.disposed(by: disposeBag)
    }
}
