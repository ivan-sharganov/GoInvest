import UIKit

extension UITableViewCell {
    static let reuseId = "reuseId"
    
    func stocksCellContentViewConfiguration() -> StocksCellContentView.Configuration {
        return StocksCellContentView.Configuration()
    }
}
