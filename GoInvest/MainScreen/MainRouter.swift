import UIKit

protocol Routable {

    func pushNext()
    func back()

}

final class MainRouter: Routable{

    // MARK: - Private properties

    private weak var viewController: UIViewController?

    // MARK: - Life cycle

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - Public methods

    func pushNext() {
        let detailViewController = DetailViewController()

        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }

}
