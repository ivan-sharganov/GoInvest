import Foundation

protocol MainRepository {

    func getStocks() async -> [StockModel]

}
// VC -> VM -> UseCase -> Repo -> NetworkManager

final class MainRepositoryImpl: MainRepository {

    public init() {}

    public func getStocks() async -> [StockModel] {
//        NetworkManager.shared.getPricesForStock { stockData in
//            stockData.stocksModels
//        }
        do {
            return try await NetworkManager.shared.analogGetPricesForStock()
        } catch {
           return []
        }
    }

}
