import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let mainViewController = MainViewController(
            viewModel: MainViewModelImpl(useCase: MainUseCaseImpl(repository: MainRepositoryImpl()))
        )
        let profileViewController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        let tabBarController = UITabBarController()

        tabBarController.setViewControllers([
            navigationController,
            profileViewController
        ], animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }

}
