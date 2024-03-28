import UIKit

protocol MainRoutable {

    func pushNext(transferModel: SecuritiesTransferModel)
    func back()

}

final class MainRouter: MainRoutable {

    // MARK: - Private properties

    private weak var viewController: UIViewController?

    // MARK: - Life cycle

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // MARK: - Public methods

    func pushNext(transferModel: SecuritiesTransferModel) {
        let viewModel = DetailViewModelImpl(transferModel: transferModel, useCase: DetailUseCaseImpl(repository: DetailRepositoryImpl()))
        let detailViewController = DetailViewController(viewModel: viewModel)

        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }

}
