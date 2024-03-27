import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        let successLoginController = UIViewController()
        successLoginController.view.backgroundColor = .systemGreen
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let credential = UserDefaults.standard.object(forKey: "user_credential") as? AuthCredential {
            FirebaseAuth.Auth.auth().signIn(with: credential) { _, error in
                if error == nil {
                    print("credential auth success!!!")
                    self.window?.rootViewController = successLoginController
                } else {
                    print("credential auth failure!!!")
                    self.window?.rootViewController = LoginViewController()
                }
            }
        } else {
            print("no credential")
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()
        
//        let mainViewController = MainViewController(
//            viewModel: MainViewModelImpl(useCase: MainUseCaseImpl(repository: MainRepositoryImpl()))
//        )
//        let profileViewController = ProfileViewController()
//
//        let navigationController = UINavigationController(rootViewController: mainViewController)
//        let backBarButtonItem = UIBarButtonItem()
//        backBarButtonItem.title = ""
//        navigationController.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
//
//        let tabBarController = UITabBarController()
//        tabBarController.tabBar.backgroundColor = .background
//        tabBarController.tabBar.tintColor = .label
//        tabBarController.tabBar.unselectedItemTintColor = .inactiveLabel
//
//        tabBarController.setViewControllers([
//            navigationController,
//            profileViewController
//        ], animated: false)
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = tabBarController
//        window?.makeKeyAndVisible()

        return true
    }

}
