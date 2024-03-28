import Foundation

protocol DetailViewModel {
    
    var allPoints: [String: PointsModel]? { get }
    var pointsModel: PointsModel? { get }
    var pricesData: [PricesModel] { get }
    var displayItem: SecuritiesDisplayItem { get }
    
    func transformPricesToPointModels(data: [PricesModel] ) -> PointsModel
    func fetchDataForTicker(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int) async
    
}

final class DetailViewModelImpl: DetailViewModel {
    
    var allPoints: [String: PointsModel]?
    var pointsModel: PointsModel?
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
    func transformPricesToPointModels( data: [PricesModel] ) -> PointsModel {
        var pointsModel = PointsModel(points: [])
        for i in data {
            guard let x = i.date, let y = i.close else {
                continue
            }
            pointsModel.points.append(PointModel(x: x, y: y))
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
            print(error.localizedDescription)
            self.pricesData = [PricesModel]()
        }
    }
    
}
