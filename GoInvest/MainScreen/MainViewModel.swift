import Foundation
import RxSwift
import RxCocoa

protocol MainViewModel {

    var cellTapped: PublishRelay<Void> { get }

    var displayItems: [StockDisplayItem] { get }

    func handleItemSelection()
    func fetchData() async

}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Public properties

    let cellTapped = PublishRelay<Void>()

    var displayItems: [StockDisplayItem] = []

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

    // сделать енум параметров (индексы, фьючерсы и тд)
    public func fetchData() async {
        do {
            self.displayItems = try await prepareDisplayItems(stockModels: self.useCase.get())
        } catch {
            self.displayItems = []
        }
    }
    
    // MARK: - Private methods
    
    private func prepareDisplayItems(stockModels: [StockModel]) -> [StockDisplayItem] {
        stockModels.map {
            StockDisplayItem(name: $0.shortName,
                             shortName: $0.ticker,
                             closePrice: $0.close,
                             trendclspr: $0.trendclspr)
        }
    }
    
}
