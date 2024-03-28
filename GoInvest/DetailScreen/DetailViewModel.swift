import Foundation

protocol DetailViewModel {
    
    var allPoints: PointModels? { get }
    var pointsModel: PointModel? { get }
    var pricesData: [PricesModel] { get }
    var displayItem: SecuritiesDisplayItem { get }
    
    func transformPricesToPointModels(data: [PricesModel] ) -> PointModels
    func fetchDataForTicker(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int) async
    
}

final class DetailViewModelImpl: DetailViewModel {
    
    var allPoints: PointModels?
    var pointsModel: PointModel?
    var pricesData = [PricesModel]()
    var displayItem: SecuritiesDisplayItem
    
    let useCase: DetailUseCase
    
    // MARK: - Life cycle

    init(transferModel: SecuritiesTransferModel, useCase: DetailUseCase) {
        self.useCase = useCase
        self.displayItem = SecuritiesDisplayItem(title: transferModel.title,
                                                 subtitle: transferModel.subtitle,
                                                 priceChange: transferModel.priceChange,
                                                 price: transferModel.price)
        
        Task {
            await fetchDataForTicker(ticker: transferModel.ticker,
                                     parameter: transferModel.stockState)
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
    
    public func fetchDataForTicker(ticker: String, parameter: StockState, range: GraphRangeValues = .oneDay, interval: Int = 20) async {
        do {
            self.pricesData = try await self.useCase.get(ticker: ticker,
                                                         parameter: parameter,
                                                         range: .oneDay,
                                                         interval: interval)
        } catch {
            self.pricesData = [PricesModel]()
        }
    }
    
}
