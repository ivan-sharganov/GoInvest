import UIKit

final class TextField: UITextField {
    
    // MARK: - Constants
    
    private struct Constants {
        static let insets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        static let font = UIFont.systemFont(ofSize: 17)
        static let backgroundColor: UIColor = .systemGray6
    }
    
    // MARK: - Init
    
    init(placeholder: String, isSecure: Bool) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        backgroundColor = Constants.backgroundColor
        font = Constants.font
        isSecureTextEntry = isSecure
        autocapitalizationType = .none
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: Constants.insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: Constants.insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: Constants.insets)
    }
    
}
