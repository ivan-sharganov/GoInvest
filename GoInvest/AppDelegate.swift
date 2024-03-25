import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let mainViewController = MainViewController(viewModel: MainViewModelImpl(useCase: MainUseCaseImpl()))
        let navigationController = UINavigationController(rootViewController: mainViewController)
        let tabBarController = UITabBarController()
        let backBarButtonItem = UIBarButtonItem()
        
        tabBarController.setViewControllers([navigationController], animated: true)
        
        backBarButtonItem.title = ""
        navigationController.navigationBar.topItem?.backBarButtonItem = backBarButtonItem

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }

}
