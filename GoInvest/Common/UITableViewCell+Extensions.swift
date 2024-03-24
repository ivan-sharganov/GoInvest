import UIKit

// MARK: - UITableViewCell

extension UITableViewCell {
    
    static let reuseId = String(describing: UITableViewCell.self)
    
    func stocksCellContentViewConfiguration() -> StocksCellContentView.Configuration {
        StocksCellContentView.Configuration()
    }
    
}
