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
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        FirebaseManager.shared.addItems([StockDisplayItem(name: "AAAA", shortName: "BBBBB", openPrice: 1.123, closePrice: 231.12, highPrice: 12.1, lowPrice: 21.1, boardID: "Adsdsd")])

        return true
    }

}
