import Foundation
import RxSwift
import RxCocoa

enum StockState: String {
    
    case indexes
    case shares
    case bonds
    
}

protocol MainViewModel {

    var cellTapped: Signal<Void> { get }
    var updateSnapshot: Signal<Bool> { get }

    var displayItems: [StockDisplayItem] { get }
    var responseItems: [StockDisplayItem] { get }
    
    var market: StockState { get set }

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

    var market: StockState = .shares
    
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
            await fetchData(parameters: stockState) // TODO: Сделать еще 5 запросов после этого
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
            self.displayItems = self.responseItems.filter { $0.name.uppercased().contains(query.uppercased()) }
        }
        _updateSnapshot.accept(false)
    }

    public func fetchData(parameters: StockState) async {
        do {
            self.responseItems = try await prepareDisplayItems(stockModels: self.useCase.get(parameters: parameters))
            self.displayItems = responseItems
            
            self.market = parameters
        } catch {
            self.responseItems = []
        }
    }
    
    // MARK: - Private methods
    
    private func prepareDisplayItems(stockModels: [StockModel]) -> [StockDisplayItem] {
        stockModels.compactMap {
            guard let name = $0.shortName,
                  let shortName = $0.ticker,
                  let openPrice = $0.open,
                  let closePrice = $0.close,
                  let highPrice = $0.high,
                  let lowPrice = $0.low,
                  let boardID = $0.boardID
            else {
                return nil
            }
            
            return StockDisplayItem(name: name,
                             shortName: shortName,
                             openPrice: openPrice,
                             closePrice: closePrice,
                             highPrice: highPrice,
                             lowPrice: lowPrice,
                             boardID: boardID
                            ) // trendclspr: $0.trendclspr
        }
    }
    
}
