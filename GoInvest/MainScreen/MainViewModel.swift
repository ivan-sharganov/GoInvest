import Foundation
import RxSwift
import RxCocoa

enum StockState {
    
    case indexes
    case shares
    case bonds
    
}

protocol MainViewModel {

    var cellTapped: Signal<Void> { get }
    var updateSnapshot: Signal<Bool> { get }

    var displayItems: [StockDisplayItem] { get }
    var responseItems: [StockDisplayItem] { get }

    func handleItemSelection()
    func fetchData(parameters: StockState) async
    func chooseStockStateData(stockState: StockState)
    func searchItems(for query: String?)

}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Public properties

    /// Эти проперти кастятся к Signal, чтобы работать в main потоке на ViewController
    var cellTapped: Signal<Void> { _cellTapped.asSignal() }
    var updateSnapshot: Signal<Bool> { _updateSnapshot.asSignal() }

    var displayItems: [StockDisplayItem] = []
    var responseItems: [StockDisplayItem] = []
    
    private let _updateSnapshot = PublishRelay<Bool>()
    private let _cellTapped = PublishRelay<Void>()

    // MARK: - Private properties

    let useCase: MainUseCase

    // MARK: - Life cycle

    init(useCase: MainUseCase) {
        self.useCase = useCase
        
        Task {
            await fetchData(parameters: .indexes)
            _updateSnapshot.accept((true))
        }
    }

    // MARK: - Public methods

    func handleItemSelection() {
        _cellTapped.accept(())
    }
    
    func chooseStockStateData(stockState: StockState) {
        Task {
            await fetchData(parameters: stockState)
            _updateSnapshot.accept((false))
        }
    }
        
    func searchItems(for query: String?) {
        guard let query else {
            self.displayItems = self.responseItems
            
            return
        }
        
        if query.isEmpty {
            self.displayItems = self.responseItems
        } else {
            self.displayItems = self.responseItems.filter { $0.name?.uppercased().contains(query.uppercased()) ?? false }
        }
        _updateSnapshot.accept(false)
    }

    public func fetchData(parameters: StockState) async {
        do {
            self.responseItems = try await prepareDisplayItems(stockModels: self.useCase.get(parameters: parameters))
            self.displayItems = responseItems
        } catch {
            self.responseItems = []
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
