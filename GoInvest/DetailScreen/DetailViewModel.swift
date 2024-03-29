import Foundation
import RxSwift
import RxCocoa

protocol DetailViewModel {
    
    var didFetchPoints: Signal<PointModels> { get }
    var didChangeFunc: Signal<PointModels> { get }
    
    var allRequestsPoints: [GraphRangeValues: PointModels] { get set }
    var pointsForExtraGraph: PointModels { get set }
    var allPoints: PointModels { get }
    var pointsModel: PointModel? { get }
    var pricesData: [PricesModel] { get }
    var displayItem: SecuritiesDisplayItem { get }
    var transferModel: SecuritiesTransferModel { get }

    func didChooseFunction(value: Int)
    func didChooseRangeData(value: Int)
    func transformPricesToPointModels(data: [PricesModel] ) -> PointModels
    func fetchDataForTicker(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int)
    async
    
}

final class DetailViewModelImpl: DetailViewModel {
    
    var allRequestsPoints = [GraphRangeValues: PointModels]()
    
    var didFetchPoints: Signal<PointModels> { _didFetchPoints.asSignal() }
    var didChangeFunc: Signal<PointModels> { _didChangeFunc.asSignal() }
    
    var pointsForExtraGraph = PointModels(points: [])
    var allPoints = PointModels(points: [])
    var pointsModel: PointModel?
    var pricesData = [PricesModel]()
    var displayItem: SecuritiesDisplayItem
    var transferModel: SecuritiesTransferModel
    
    let useCase: DetailUseCase
    
    var function: MathFunctions = .SMA
    
    private let _didFetchPoints = PublishRelay<PointModels>()
    private let _didChangeFunc = PublishRelay<PointModels>()
    
    // MARK: - Life cycle
    
    init(transferModel: SecuritiesTransferModel, useCase: DetailUseCase) {
        self.transferModel = transferModel
        self.useCase = useCase
        self.displayItem = SecuritiesDisplayItem(title: transferModel.title,
                                                 subtitle: transferModel.subtitle,
                                                 priceChange: transferModel.priceChange,
                                                 price: transferModel.price)
        
        Task {
            for range in GraphRangeValues.allCases {
                await fetchDataForTicker(ticker: transferModel.ticker,
                                         parameter: transferModel.stockState, range: range)
            }
            if let allPoints = self.allRequestsPoints[.oneDay] {
                self.allPoints = allPoints
            }
            _didFetchPoints.accept(self.allPoints)
        }
    }
    
    func didChooseRangeData(value: Int) {
        if let allPoints = self.allRequestsPoints[GraphRangeValues.allCases[value]] {
            self.allPoints = allPoints
        }
        _didChangeFunc.accept(self.pointsForExtraGraph)
        _didFetchPoints.accept(self.allPoints)
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
    private func prepareFunc(value: Int) -> MathFunctions? {
        switch value {
        case 0:
            return .SMA
        case 1:
            return .EMA
        case 2:
            return .RSI
        default:
            return nil
        }
    }
    func fetchDataForTicker(ticker: String, parameter: StockState, range: GraphRangeValues = .oneDay, interval: Int = 20) async {
        do {
            self.pricesData = try await self.useCase.get(ticker: ticker,
                                                         parameter: parameter,
                                                         range: range,
                                                         interval: interval)
            let points = transformPricesToPointModels(data: self.pricesData)
            self.allRequestsPoints[range] = points
        } catch {
            self.pricesData = [PricesModel]()
        }
    }
    
    func didChooseFunction(value: Int) {
        guard let function = prepareFunc(value: value) else { return }
        
        self.function = function
        switch function {
        case .SMA:
            self.pointsForExtraGraph.points = MathManager.sma(points: self.allPoints.points)
        case .EMA:
            self.pointsForExtraGraph.points = MathManager.ema(points: self.allPoints.points)
        case .RSI:
            self.pointsForExtraGraph.points = MathManager.rsi(points: self.allPoints.points)
        }
        _didFetchPoints.accept(self.allPoints)
        _didChangeFunc.accept(self.pointsForExtraGraph)
    }
    
}
