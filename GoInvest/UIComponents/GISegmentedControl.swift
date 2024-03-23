import UIKit

class GISegmentedControl: UISegmentedControl {
    override init(items: [Any]?) {
        super.init(items: items)
        self.selectedSegmentIndex = 0
        self.selectedSegmentTintColor = .accent
        self.backgroundColor = .background
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
