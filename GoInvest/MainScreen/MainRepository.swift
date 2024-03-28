import Foundation

protocol MainRepository {

    func getStocks(parameters: StockState) async throws -> [StockModel]

}

final class MainRepositoryImpl: MainRepository {

    public init() {}

    public func getStocks(parameters: StockState) async throws -> [StockModel] {
        switch parameters {
        case .shares:
            return try await NetworkManager.shared.getPricesForStock(parameter: "shares")
        case .index:
            return try await NetworkManager.shared.getPricesForStock(parameter: "index")
        case .bonds:
            return try await NetworkManager.shared.getPricesForStock(parameter: "bonds")
        }
    }

}
