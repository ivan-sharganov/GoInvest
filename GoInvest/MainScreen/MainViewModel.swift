import Foundation
import RxSwift
import RxCocoa

enum StockState {
    
    case indexes
    case shares
    case bonds
    
}

protocol MainViewModel {

    var cellTapped: PublishRelay<Void> { get }
    var updateSnapshot: PublishRelay<Bool> { get }

    var displayItems: [StockDisplayItem] { get }

    func handleItemSelection()
    func fetchData(parameters: StockState) async
    func chooseStockStateData(stockState: StockState)

}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Public properties

    let cellTapped = PublishRelay<Void>()
    var updateSnapshot = PublishRelay<Bool>()

    var displayItems: [StockDisplayItem] = []

    // MARK: - Private properties

    let useCase: MainUseCase

    // MARK: - Life cycle

    init(useCase: MainUseCase) {
        self.useCase = useCase
        
        Task {
            await fetchData(parameters: .indexes)
            updateSnapshot.accept((true))
        }
    }

    // MARK: - Public methods

    func handleItemSelection() {
        cellTapped.accept(())
    }
    
    func chooseStockStateData(stockState: StockState) {
        Task {
            await fetchData(parameters: stockState)
            updateSnapshot.accept((false))
        }
    }

    public func fetchData(parameters: StockState) async {
        do {
            self.displayItems = try await prepareDisplayItems(stockModels: self.useCase.get(parameters: parameters))
            print(self.displayItems)
        } catch {
            self.displayItems = []
        }
    }
    
    // MARK: - Private methods
    
    private func prepareDisplayItems(stockModels: [StockModel]) -> [StockDisplayItem] {
        stockModels.map {
            StockDisplayItem(name: $0.shortName,
                             shortName: $0.ticker,
                             openPrice: $0.open,
                             closePrice: $0.close,
                             highPrice: $0.high,
                             lowPrice: $0.low) // trendclspr: $0.trendclspr
        }
    }
    
}
