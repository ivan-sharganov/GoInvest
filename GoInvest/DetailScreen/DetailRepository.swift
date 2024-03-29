import Foundation

protocol DetailRepository {

    func getValues(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int) async throws -> [PricesModel]

}

final class DetailRepositoryImpl: DetailRepository {

    public init() {}
        
    public func getValues(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int) async throws -> [PricesModel] {
        let from = Date.now.addOrSubtractDay(day: -range.rawValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return try await NetworkManager.shared.getPricesForTicker(parameter: parameter.rawValue, ticker: ticker, from: dateFormatter.string(from: from), till: dateFormatter.string(from: Date.now.addOrSubtractDay(day: -1)), interval: interval)
    }
    
}
