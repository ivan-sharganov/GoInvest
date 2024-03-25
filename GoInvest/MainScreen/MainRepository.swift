import Foundation

protocol MainRepository {

    func getStocks(parameters: StockState) async throws -> [StockModel]

}

final class MainRepositoryImpl: MainRepository {

    public init() {}

    public func getStocks(parameters: StockState) async throws -> [StockModel] {
        switch parameters {
        case .indexes:
            try await NetworkManager.shared.analogGetPricesForStock(parameter: "index")
        case .futures:
            try await NetworkManager.shared.analogGetPricesForStock(parameter: "shares")
        case .currencies:
            try await NetworkManager.shared.analogGetPricesForStock(parameter: "bonds")
        }
    }

}
