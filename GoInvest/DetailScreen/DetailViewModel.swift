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
            await fetchDataForTicker(stockItem: StockDisplayItem() ) // получить из роутера stockItem - сделать поле во вью моделе???
        }
    }
    
    func transformPricesToPointModels( data: [PricesModel], range: Int = 0 ) -> PointsModel {
//        var max = Double(Int.min)
//        var min = Double(Int.max)
        var pointsModel = PointsModel(points: [])
        for i in data {
            guard let x = i.date, let y = i.close else {
                continue
            }
            pointsModel.points.append(PointModel(x: x, y: y))
//            if x > max {
//                max = x
//            } else if x < min {
//                min = x
//            }
        }
            
        return pointsModel
    }
    
    public func fetchDataForTicker(stockItem: StockDisplayItem) async {
        do {
            self.pricesData = try await self.useCase.get(stockItem: StockDisplayItem(), parameter: .shares, range: .oneDay, board: "TQBR", interval: 12)
        } catch {
            self.pricesData = [PricesModel]()
        }
    }
}
