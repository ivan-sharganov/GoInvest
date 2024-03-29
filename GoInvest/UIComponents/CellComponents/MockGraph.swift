import UIKit

final class MockGraph: UIView {
    
    // MARK: - Public propery
    
    var priceChange: Double = 0
    
    // MARK: - Life cycle
    
    init() {

        super.init(frame: .zero)

        backgroundColor = .clear

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),
            widthAnchor.constraint(equalToConstant: 96)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    override func draw(_ rect: CGRect) {
        let color = priceChange >= 0 ? UIColor.systemGreen : UIColor.systemRed
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: Int.random(in: 0...10), y: Int.random(in: 30...48)))
        path.addLine(to: CGPoint(x: Int.random(in: 10...15), y: Int.random(in: 20...45)))
        path.addLine(to: CGPoint(x: Int.random(in: 15...25), y: Int.random(in: 10...20)))
        path.addLine(to: CGPoint(x: Int.random(in: 25...40), y: Int.random(in: 25...38)))
        path.addLine(to: CGPoint(x: Int.random(in: 40...55), y: Int.random(in: 20...30)))
        path.addLine(to: CGPoint(x: Int.random(in: 55...65), y: Int.random(in: 0...48)))
        path.addLine(to: CGPoint(x: Int.random(in: 65...85), y: Int.random(in: 0...48)))
        path.addLine(to: CGPoint(x: Int.random(in: 85...90), y: Int.random(in: 0...48)))
        color.set()
        path.lineWidth = 4
        path.stroke()
    }
    
}
