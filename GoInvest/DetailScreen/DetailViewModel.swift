import Foundation

protocol DetailViewModel {
    
    func transformPricesToPointModels(data: [PricesModel] ) -> PointsModel
    
    func fetchDataForTicker(ticker: String, parameter: StockState, interval: Int) async
    
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
            await fetchDataForTicker(ticker: "AFLT", parameter: .shares) // TODO: Кирилл, пробрось данные сюда
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
    
    public func fetchDataForTicker(ticker: String, parameter: StockState, interval: Int = 20 ) async {
        do {
            self.pricesData = try await self.useCase.get(ticker: ticker, parameter: parameter, range: .oneDay, interval: interval)
        } catch {
            self.pricesData = [PricesModel]()
        }
    }
}
