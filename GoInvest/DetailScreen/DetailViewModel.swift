import Foundation

protocol DetailViewModel {
    
    func transformPricesToPointModels(data: [PricesModel], range: Int) -> PointsModel
    
    func fetchDataForTicker(stockItem: StockDisplayItem) async
    
}

class DetailViewModelImpl: DetailViewModel {
    
    var allPoints: [String: PointsModel]?
    
    var pointsModel: PointsModel?
    
    var pricesData = [PricesModel]()
    
    let useCase: DetailUseCase
    
    // MARK: - Life cycle

    init(useCase: DetailUseCase) {
        self.useCase = useCase
        
        Task {
            /// получить из роутера stockItem - сделать поле во вью моделе???/
//            await fetchDataForTicker(stockItem: StockDisplayItem() )
        }
    }
    /// Функция перевода данных к виду для графиков
    func transformPricesToPointModels( data: [PricesModel], range: Int = 0 ) -> PointsModel {
        var pointsModel = PointsModel(points: [])
        for i in data {
            guard let x = i.date, let y = i.close else {
                continue
            }
            pointsModel.points.append(PointModel(x: x, y: y))
        }
            
        return pointsModel
    }
    
    public func fetchDataForTicker(stockItem: StockDisplayItem) async {
        do {
//            let mockStockItem = StockDisplayItem(shortName: "YNDX")
            self.pricesData = try await self.useCase.get(stockItem: stockItem, parameter: .shares, range: .oneDay, board: "TQBR", interval: 12)
        } catch {
            self.pricesData = [PricesModel]()
        }
    }
}
