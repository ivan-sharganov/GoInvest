import Foundation

struct StockDisplayItem: Hashable {
    
    var name: String
    var shortName: String
    var openPrice: Double
    var closePrice: Double
    var highPrice: Double
    var lowPrice: Double
    var boardID: String
//    var trendclspr: Double?
    var isFavorite: Bool = false
    
    var rate: Double {
        abs((openPrice - closePrice) / (highPrice - lowPrice)) * 10
    }
    
}
