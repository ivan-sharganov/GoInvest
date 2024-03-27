import Foundation

protocol DetailRepository {

    func getValues(stockItem: StockDisplayItem, parameter: StockState, range: GraphRangeValues, board: String, interval: Int) async throws -> [PricesModel]

}

final class DetailRepositoryImpl: DetailRepository {

    public init() {}
        
    public func getValues(stockItem: StockDisplayItem, parameter: StockState, range: GraphRangeValues, board: String, interval: Int) async throws -> [PricesModel] {
        let from = Date.now.addOrSubtractDay(day: range.rawValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        print(dateFormatter.string(from: from))
        return try await NetworkManager.shared.getPricesForTicker(parameter: parameter.rawValue, board: board, ticker: stockItem.shortName ?? "YNDX", from: dateFormatter.string(from: from), till: dateFormatter.string(from: Date.now), interval: interval)
    }
    
}
