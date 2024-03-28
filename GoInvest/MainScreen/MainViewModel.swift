import Foundation
import RxSwift
import RxCocoa

enum StockState: String {
    
    case shares
    case index
    case bonds
    
}

protocol MainViewModel {

    var cellTapped: Signal<SecuritiesTransferModel> { get }
    var updateSnapshot: Signal<Bool> { get }

    var displayItems: [StockDisplayItem] { get }
    var responseItems: [StockDisplayItem] { get }
    
    var stockState: StockState { get set }

    func handleItemSelection(item: StockDisplayItem, stockState: StockState)
    func fetchData(parameters: StockState) async
    func chooseStockStateData(stockState: StockState)
    func searchItems(for query: String?)

}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Public properties

    /// Эти проперти кастятся к Signal, чтобы работать в main потоке на ViewController
    var cellTapped: Signal<SecuritiesTransferModel> { _cellTapped.asSignal() }
    var updateSnapshot: Signal<Bool> { _updateSnapshot.asSignal() }

    var displayItems: [StockDisplayItem] = []
    var responseItems: [StockDisplayItem] = []
    
    private let _updateSnapshot = PublishRelay<Bool>()
    private let _cellTapped = PublishRelay<SecuritiesTransferModel>()

    var stockState: StockState = .shares
    
    // MARK: - Private properties

    let useCase: MainUseCase

    // MARK: - Life cycle

    init(useCase: MainUseCase) {
        self.useCase = useCase
        
        Task {
            await fetchData(parameters: .shares)
            _updateSnapshot.accept((true))
        }
    }

    // MARK: - Public methods

    func handleItemSelection(item: StockDisplayItem, stockState: StockState) {
        let securitiesTranferModel = SecuritiesTransferModel(title: item.name, 
                                                             subtitle: item.shortName,
                                                             ticker: item.shortName,
                                                             stockState: stockState,
                                                             isFavorite: item.isFavorite,
                                                             priceChange: item.priceChange,
                                                             price: item.closePrice)
        _cellTapped.accept((securitiesTranferModel))
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
            
            self.stockState = parameters
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
                             boardID: boardID)
        }
    }
    
}
