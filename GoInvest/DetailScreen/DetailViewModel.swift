import Foundation
import RxSwift
import RxCocoa

protocol DetailViewModel {
    
    var didFetchPoints: Signal<PointModels> { get }
    
    var allPoints: PointModels { get }
    var pointsModel: PointModel? { get }
    var pricesData: [PricesModel] { get }
    var displayItem: SecuritiesDisplayItem { get }
    var transferModel: SecuritiesTransferModel { get }
    
    func transformPricesToPointModels(data: [PricesModel] ) -> PointModels
    func fetchDataForTicker(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int)
    async
    
}

final class DetailViewModelImpl: DetailViewModel {
    
    var didFetchPoints: Signal<PointModels> { _didFetchPoints.asSignal() }
    
    var allPoints = PointModels(points: [])
    var pointsModel: PointModel?
    var pricesData = [PricesModel]()
    var displayItem: SecuritiesDisplayItem
    var transferModel: SecuritiesTransferModel
    
    let useCase: DetailUseCase
    
    private let _didFetchPoints = PublishRelay<PointModels>()
    
    // MARK: - Life cycle

    init(transferModel: SecuritiesTransferModel, useCase: DetailUseCase) {
        self.transferModel = transferModel
        self.useCase = useCase
        self.displayItem = SecuritiesDisplayItem(title: transferModel.title,
                                                 subtitle: transferModel.subtitle,
                                                 priceChange: transferModel.priceChange,
                                                 price: transferModel.price)
        
        Task {
//            for range in GraphRangeValues.allCases {
//                await fetchDataForTicker(ticker: transferModel.ticker,
//                                         parameter: transferModel.stockState, range: range)
//            }
            await fetchDataForTicker(ticker: transferModel.ticker,
                                     parameter: transferModel.stockState)
            _didFetchPoints.accept(self.allPoints)
        }
    }
    
    /// Функция перевода данных к виду для графиков
    func transformPricesToPointModels(data: [PricesModel] ) -> PointModels {
        var pointsModel = PointModels(points: [])
        for i in data {
            guard let x = i.date, let y = i.close else {
                continue
            }
            pointsModel.points.append(PointModel(x: x, y: y, id: UUID()))
        }
            
        return pointsModel
    }
    
    func fetchDataForTicker(ticker: String, parameter: StockState, range: GraphRangeValues = .oneDay, interval: Int = 20) async {
        do {
            self.pricesData = try await self.useCase.get(ticker: ticker,
                                                         parameter: parameter,
                                                         range: range,
                                                         interval: interval)
            // let points = transformPricesToPointModels(data: self.pricesData)
            // self.allPoints[range] = points
            self.allPoints = transformPricesToPointModels(data: self.pricesData)
        } catch {
            self.pricesData = [PricesModel]()
        }
    }
    
}
