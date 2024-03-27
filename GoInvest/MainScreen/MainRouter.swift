import UIKit

protocol Routable {

    func pushNext()
    func back()

}

final class MainRouter: Routable {

    // MARK: - Private properties

    private weak var viewController: UIViewController?

    // MARK: - Life cycle

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - Public methods

    func pushNext() {
        let detailViewController = DetailViewController(
            viewModel: DetailViewModelImpl(useCase: DetailUseCaseImpl(repository: DetailRepositoryImpl()))
        )

        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }

}
