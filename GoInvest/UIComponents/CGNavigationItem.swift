import UIKit

class CGNavigationLabel: UIView {
    private var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("Selected", for: .selected)
        button.setTitle("Normal", for: .normal)
        button.setTitleColor(.black, for: .normal)
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    private var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("Selected", for: .selected)
        button.setTitle("Normal", for: .normal)
        button.setTitleColor(.black, for: .normal)
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }()
    
    public func configure() {
        
    }
    override func layoutSubviews() {
        self.addSubview(self.stackView)
        self.stackView.addSubview(self.leftButton)
        self.stackView.addSubview(self.rightButton)
        
        let constraints = [
            self.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
        // This will assing your custom view to navigation title.
//    navigationItem.titleView = stackView
    
}
