import Foundation
import RxSwift
import RxCocoa

enum StockState: String {
    case shares
    case index
    case bonds
}

enum SecuritiesSource {
    case apiRequest
    case favorities
}

protocol MainViewModel {
    
//    var cellTapped: Signal<SecuritiesTransferModel> { get }
    var updateSnapshot: Signal<Bool> { get }
    var didHideStackView: Signal<Bool> { get }
    
    var mainViewController: MainViewController? { get set }

    var displayItems: [StockDisplayItem] { get }
    var responseItems: [StockDisplayItem] { get }
    
    var stockState: StockState { get }
    var source: SecuritiesSource { get }

    func handleItemSelection(item: StockDisplayItem, stockState: StockState)
    func fetchData(parameters: StockState, source: SecuritiesSource) async
    func didChooseStockStateData(value: Int)
    func didChooseSecuritiesSource(value: Int)
    func searchItems(for query: String?)

}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Public properties

    /// Эти проперти кастятся к Signal, чтобы работать в main потоке на ViewController
//    var cellTapped: Signal<SecuritiesTransferModel> { _cellTapped.asSignal() }
    var updateSnapshot: Signal<Bool> { _updateSnapshot.asSignal() }
    var didHideStackView: Signal<Bool> { _didHideStackView.asSignal() }

    var displayItems: [StockDisplayItem] = []
    var responseItems: [StockDisplayItem] = []
    
    var mainViewController: MainViewController?
    
    private let _updateSnapshot = PublishRelay<Bool>()
//    private let _cellTapped = PublishRelay<SecuritiesTransferModel>()
    private let _didHideStackView = PublishRelay<Bool>()

    var stockState: StockState = .shares
    var source: SecuritiesSource = .apiRequest
    
    // MARK: - Private properties

    let useCase: MainUseCase

    // MARK: - Life cycle

    init(useCase: MainUseCase) {
        self.useCase = useCase
        
        Task {
            await fetchData(parameters: self.stockState, source: self.source)
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
        
        mainViewController?.router.pushNext(transferModel: securitiesTranferModel, stockDisplayItem: item)
//        _cellTapped.accept((securitiesTranferModel))
    }
    
    func didChooseStockStateData(value: Int) {
        guard let stockState = prepareStateData(value: value) else { return }
        
        self.stockState = stockState
        Task {
            await fetchData(parameters: stockState, source: source) // TODO: Сделать еще 5 запросов после этого
            _updateSnapshot.accept((false)) // анимация
        }
    }
    
    func didChooseSecuritiesSource(value: Int) {
        guard let source = prepareSecuritiesSource(value: value) else { return }
        
        self.source = source
        Task {
            await fetchData(parameters: stockState, source: source) // TODO: Сделать еще 5 запросов после этого
            _updateSnapshot.accept((false)) // анимация
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

    public func fetchData(parameters: StockState, source: SecuritiesSource) async {
        switch source {
        case .apiRequest:
            do {
                self._didHideStackView.accept(false)
                self.responseItems = try await prepareDisplayItems(stockModels: self.useCase.get(parameters: parameters))
                self.displayItems = responseItems
                self.stockState = parameters
                self.source = source
            } catch {
                self.responseItems = []
            }
        case .favorities:
            FirebaseManager.shared.getItems(
                kind: .favorite,
                completition: { result in
                    switch result {
                    case .success(let items):
                        self.responseItems = items
                        self.displayItems = items
                        self._updateSnapshot.accept(false)
                        self._didHideStackView.accept(true)
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
            )
        }
        
    }
    
    // MARK: - Private methods
    
    private func prepareStateData(value: Int) -> StockState? {
        switch value {
        case 0:
            return .shares
        case 1:
            return .index
        case 2:
            return .bonds
        default:
            return nil
        }
    }
    
    private func prepareSecuritiesSource(value: Int) -> SecuritiesSource? {
        switch value {
        case 0:
            return .apiRequest
        case 1:
            return .favorities
        default:
            return nil
        }
    }
    
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
