import Foundation

struct StockDisplayItem: Hashable, Decodable {
    
    var name: String
    var shortName: String
    var openPrice: Double
    var closePrice: Double
    var highPrice: Double
    var lowPrice: Double
    var boardID: String
    var isFavorite: Bool = false
    
    var priceChange: Double {
        Double(100) - (openPrice / closePrice) * Double(100)
    }
    
    var rate: Double {
        abs((openPrice - closePrice) / (highPrice - lowPrice)) * 10
    }
    
}
