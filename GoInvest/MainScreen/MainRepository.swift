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
        case .futures:
            return try await NetworkManager.shared.analogGetPricesForStock(parameter: "shares")
        case .currencies:
            return try await NetworkManager.shared.analogGetPricesForStock(parameter: "bonds")
        }
    }

}
