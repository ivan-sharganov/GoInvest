import Foundation

protocol MainRepository {

    func getStocks(parameters: StockState) async throws -> [StockModel]

}

final class MainRepositoryImpl: MainRepository {

    public init() {}

    public func getStocks(parameters: StockState) async throws -> [StockModel] {
        do {
            let answer = try await NetworkManager.shared.getPricesForStock(parameter: parameters.rawValue)
            CachingClass.shared.saveCache(records: StockData(stocksModels: answer), key: parameters.rawValue)
            return answer
        } catch {
            // TODO: обработать, что данные из кэша и показать алерт
            if let data = CachingClass.shared.getCache(for: parameters.rawValue)?.stocksModels {
                return data
            } else {
                return [StockModel]()
            }
        }
        
    }

}
