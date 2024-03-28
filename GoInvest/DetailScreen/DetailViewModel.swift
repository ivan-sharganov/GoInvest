import Foundation

protocol DetailViewModel {
    
    var allPoints: [GraphRangeValues: PointsModel] {get set}
    var pointsModel: PointsModel? { get }
    var pricesData: [PricesModel] { get }
    var displayItem: SecuritiesDisplayItem { get }
    
    func transformPricesToPointModels(data: [PricesModel] ) -> PointsModel
    func fetchDataForTicker(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int) async
    
}

final class DetailViewModelImpl: DetailViewModel {
    
    var allPoints = [GraphRangeValues: PointsModel]()
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
            for i in GraphRangeValues.allCases {
                await fetchDataForTicker(ticker: transferModel.ticker,
                                         parameter: transferModel.stockState, range: i)
            }
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
                                                         range: range,
                                                         interval: interval)
            let points = transformPricesToPointModels(data: self.pricesData)
            self.allPoints[range] = points
        } catch {
            print(error.localizedDescription)
            self.pricesData = [PricesModel]()
        }
    }
    
}
