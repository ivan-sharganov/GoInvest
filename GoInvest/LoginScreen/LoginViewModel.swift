import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

protocol LoginViewModel {
    
    func logIn(email: String, password: String) -> Bool
    
    func createAccount(email: String, password: String) -> Bool
    
    func logOut()
    
}

final class LoginViewModelImpl: LoginViewModel {
    
    /// Login using email and password.
    func logIn(email: String, password: String) -> Bool {
        var isSuccesful: Bool = false
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print(error.localizedDescription)
                isSuccesful = false
            } else {
                isSuccesful = true
            }
            
        }
        
        return isSuccesful
    }

    /// Creates new account using email and password.
    func createAccount(email: String, password: String) -> Bool {
        var isSuccesful: Bool = false
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                print(error.localizedDescription)
                isSuccesful = false
            } else {
                isSuccesful = true
            }
            
        }
        
        return isSuccesful
    }
    
    func logOut() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}
