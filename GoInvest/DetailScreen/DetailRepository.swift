import Foundation

protocol DetailRepository {

    func getValues(stockItem: StockDisplayItem) async throws -> [PricesModel]

}

final class DetailRepositoryImpl: DetailRepository {

    public init() {}
        
    public func getValues(stockItem: StockDisplayItem) async throws -> [PricesModel] {
        
    }

}
