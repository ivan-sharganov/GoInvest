import UIKit

protocol LoginRoutable {
    
    func pushNext()
    func back()
    
}

final class LoginRouter: LoginRoutable {
    
    // MARK: - Private properties

    private weak var loginViewController: LoginViewController?

    // MARK: - Life cycle

    init(loginViewController: LoginViewController? = nil) {
        self.loginViewController = loginViewController
    }

    // MARK: - Public methods

    func pushNext() {
        // main screen
        let mainViewController = MainViewController(
            viewModel: MainViewModelImpl(useCase: MainUseCaseImpl(repository: MainRepositoryImpl()))
        )
        // profile screen
        let profileViewController = ProfileViewController()

        // navigation (main -> detail)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        navigationController.navigationBar.topItem?.backBarButtonItem = backBarButtonItem

        // tabs (navigation + profile)
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .background
        tabBarController.tabBar.tintColor = .label
        tabBarController.tabBar.unselectedItemTintColor = .inactiveLabel
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.setViewControllers([
            navigationController,
            profileViewController
        ], animated: false)

        loginViewController?.present(tabBarController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: DispatchWorkItem(block: {
            self.back()
        }))
    }

    func back() {
        loginViewController?.dismiss(animated: true)
    }
    
}
