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
        
        let testItem = StockDisplayItem(name: "test2", shortName: "TEST2", openPrice: 1.1, closePrice: 1.2, highPrice: 2.1, lowPrice: 2.2, boardID: "test")
        
//        FirebaseManager.shared.addItems([testItem])
        
        DispatchQueue.global().async {
            FirebaseManager.shared.getItem(shortName: "TEST") { result in
                switch result {
                case .success(let item):
                    print(item)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }

        return true
    }

}
