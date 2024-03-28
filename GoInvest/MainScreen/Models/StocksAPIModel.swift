import Foundation

struct StockData: Codable {

    let stocksModels: [StockModel]

}

struct StockModel: Hashable, Codable {

    /// Название компании
    var shortName: String?

    /// Тикер(короткая сокращение) компании
    var ticker: String?
    
    var open: Double?

    /// Цена закрытия
    var close: Double?
    
    var high: Double?
    
    var low: Double?

    /// Коэфициент разницы между последней ценой закрытия и текущей
    var trendclspr: Double?
    
    var boardID: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(ticker)
    }
    
}
