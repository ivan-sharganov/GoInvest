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
        
        try! FirebaseAuth.Auth.auth().signOut()
        
        let mainViewController = MainViewController(
            viewModel: MainViewModelImpl(useCase: MainUseCaseImpl(repository: MainRepositoryImpl()))
        )
        let profileViewController = ProfileViewController()

        let navigationController = UINavigationController(rootViewController: mainViewController)
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        navigationController.navigationBar.topItem?.backBarButtonItem = backBarButtonItem

        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .background
        tabBarController.tabBar.tintColor = .label
        tabBarController.tabBar.unselectedItemTintColor = .inactiveLabel

        tabBarController.setViewControllers([
            navigationController,
            profileViewController
        ], animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = FirebaseAuth.Auth.auth().currentUser == nil ?  LoginViewController(loginViewModel: LoginViewModelImpl()) : tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

}
