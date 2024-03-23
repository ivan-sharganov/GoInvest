import UIKit

final class MockGraph: UIView {
    // MARK: - Initialization
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),
            widthAnchor.constraint(equalToConstant: 96)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 48))
        path.addLine(to: CGPoint(x: 10, y: 40))
        path.addLine(to: CGPoint(x: 23, y: 10))
        path.addLine(to: CGPoint(x: 33, y: 35))
        path.addLine(to: CGPoint(x: 45, y: 29))
        path.addLine(to: CGPoint(x: 53, y: 16))
        path.addLine(to: CGPoint(x: 78, y: 9))
        path.addLine(to: CGPoint(x: 96, y: 0))
        UIColor.systemGreen.set()
        path.lineWidth = 4
        path.stroke()
    }
}
