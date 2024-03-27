import Foundation

struct StockDisplayItem: Hashable {
    
    var name: String?
    var shortName: String?
    var openPrice: Double?
    var closePrice: Double?
    var highPrice: Double?
    var lowPrice: Double?
    var boardID: String?
//    var trendclspr: Double?
    var isFavorite: Bool = false
    
    var rate: Double? {
        guard let openPrice,
              let closePrice,
              let highPrice,
              let lowPrice,
              let boardID
        else {
            return nil
        }
        
        return abs((openPrice - closePrice) / (highPrice - lowPrice)) * 10
    }
    
}
