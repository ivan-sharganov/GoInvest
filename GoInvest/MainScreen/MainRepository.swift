import Foundation

protocol MainRepository {

    func getStocks() async throws -> [StockModel]

}
// VC -> VM -> UseCase -> Repo -> NetworkManager

final class MainRepositoryImpl: MainRepository {

    public init() {}

    public func getStocks() async throws -> [StockModel] {
        try await NetworkManager.shared.analogGetPricesForStock()
    }

}
