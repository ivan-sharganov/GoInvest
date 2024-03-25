import Foundation
import RxSwift
import RxCocoa

protocol MainViewModel {

    var cellTapped: PublishRelay<Void> { get }

    var displayItems: [StockModel] { get }

    func handleItemSelection()
    func fetchData() async

}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Public properties

    let cellTapped = PublishRelay<Void>()

    var displayItems: [StockModel] = []

    // MARK: - Private properties

    let useCase: MainUseCase

    // MARK: - Life cycle

    init(useCase: MainUseCase) {
        self.useCase = useCase
    }

    // MARK: - Public methods

    func handleItemSelection() {
        cellTapped.accept(())
    }

    // MARK: - Private methods

    // сделать енум параметров (индексы, фьючерсы и тд)
    public func fetchData() async {
        self.displayItems = await self.useCase.get()
        print("test ", self.displayItems)
    }

}
