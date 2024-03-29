import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

protocol LoginViewModel {
    
    func logIn(email: String, password: String, completion: @escaping (AuthDataResult?, (any Error)?) -> Void)
    
    func createAccount(email: String, password: String, completion: @escaping (AuthDataResult?, (any Error)?) -> Void)
    
    func logOut()
    
}

final class LoginViewModelImpl: LoginViewModel {
    
    /// Login using email and password.
    func logIn(email: String,
               password: String,
               completion: @escaping (AuthDataResult?, (any Error)?) -> Void
    ) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    /// Creates new account using email and password.
    func createAccount(email: String, 
                       password: String,
                       completion: @escaping (AuthDataResult?, (any Error)?) -> Void
    ) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func logOut() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}
