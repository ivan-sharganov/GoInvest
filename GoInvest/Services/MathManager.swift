import Foundation

struct Point {
    let price: Double
    let date: Date
}

struct MathManager {
    static func sma(points: [Point], windowSize: Int = 20) -> [Point] {
        guard !points.isEmpty && windowSize > 0 else {
            return []
        }
        
        var averages = points
        for i in windowSize...(points.count - 1) {
            let window = points[i-windowSize..<i]
            let averagePrice = window.map { $0.price }.reduce(0.0, +) / Double(windowSize)
            let averagePoint = Point(price: averagePrice, date: points[i].date)
            averages.append(averagePoint)
        }
        
        return averages
    }
}
