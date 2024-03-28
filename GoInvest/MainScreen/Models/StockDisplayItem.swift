import Foundation

struct StockDisplayItem: Hashable, Decodable {
    
    var name: String
    var shortName: String
    var openPrice: Double
    var closePrice: Double
    var highPrice: Double
    var lowPrice: Double
    var boardID: String
<<<<<<< HEAD
    var isFavorite: Bool = false
=======
//    var trendclspr: Double?
    var isFavourite: Bool = false
>>>>>>> c152fd1 (77 fb - add get single item request)
    
    var priceChange: Double {
        Double(100) - (openPrice / closePrice) * Double(100)
    }
    
    var rate: Double {
        abs((openPrice - closePrice) / (highPrice - lowPrice)) * 10
    }
    
}
