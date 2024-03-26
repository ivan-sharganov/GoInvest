import Foundation

protocol MainRepository {

    func getStocks(parameters: StockState) async throws -> [StockModel]

}

final class MainRepositoryImpl: MainRepository {

    public init() {}

    public func getStocks(parameters: StockState) async throws -> [StockModel] {
        switch parameters {
        case .indexes:
            return try await NetworkManager.shared.analogGetPricesForStock(parameter: "index")
        case .shares:
            return try await NetworkManager.shared.analogGetPricesForStock(parameter: "shares")
        case .bonds:
            return try await NetworkManager.shared.analogGetPricesForStock(parameter: "bonds")
        }
    }

}
