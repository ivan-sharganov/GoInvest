import Foundation

protocol DetailViewModel {
    
    func transformPricesToPointModels(data: [PricesModel], range: Int) -> PointsModel
    
    func fetchDataForTicker(stockItem: StockDisplayItem) async
    
}

class DetailViewModelImpl: DetailViewModel {
    
    var allPoints: [String:PointsModel]?
    
    var pointsModel: PointsModel?
    
    var pricesData: PricesData?
    
    
    let useCase: MainUseCase
    
    // MARK: - Life cycle

    init(useCase: DetailUseCase) {
        self.useCase = useCase
        
        Task {
            await fetchDataForTicker(stockItem: <#T##StockDisplayItem#>) // получить из роутера stockItem - сделать поле во вью моделе???
        }
    }
    
    
    func transformPricesToPointModels(data: [PricesModel], range: Int = 0) -> PointsModel{
        var max = Double(Int.min)
        var min = Double(Int.max)
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
            self.responseItems = try await prepareDisplayItems(stockModels: self.useCase.get(stockItem: stockItem))
            self.displayItems = responseItems
        } catch {
            self.responseItems = []
        }
    }
}
