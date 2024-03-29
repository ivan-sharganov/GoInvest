import UIKit

protocol MainRoutable {

    func pushNext(transferModel: SecuritiesTransferModel, stockDisplayItem: StockDisplayItem)
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

    func pushNext(transferModel: SecuritiesTransferModel, stockDisplayItem: StockDisplayItem) {
        let viewModel = DetailViewModelImpl(transferModel: transferModel, useCase: DetailUseCaseImpl(repository: DetailRepositoryImpl()))
        let detailViewController = DetailViewController(viewModel: viewModel, stocksDisplayItem: stockDisplayItem)

        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }

}
