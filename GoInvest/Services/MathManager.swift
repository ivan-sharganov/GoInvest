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
    
    static func ema(points: [Point], windowSize: Int = 20) -> [Point] {
        guard !points.isEmpty && windowSize > 0 else {
            return []
        }
        var emaValues = [Point]()
        // Calculate the smoothing factor (alpha)
        let alpha = 2.0 / Double(windowSize + 1)
        // Initialize the first EMA value with the first point's price
        var ema = points.first!.price
        // Iterate through the points to calculate the EMA
        for point in points {
            // Calculate the EMA for the current point
            ema = alpha * point.price + (1 - alpha) * ema
            // Create a new Point instance with the calculated EMA and the original date
            let emaPoint = Point(price: ema, date: point.date)
            emaValues.append(emaPoint)
        }

        return emaValues
    }

    static func rsi(points: [Point], windowSize: Int = 20) -> [Point] {
        guard windowSize > 0 && windowSize <= points.count else {
            return []
        }
        var array = points
        var upSum: Double = 0
        var downSum: Double = 0
        
        // Calculate initial average gains and losses
        for i in 1..<windowSize {
            let diff = points[i].price - points[i - 1].price
            if diff > 0 {
                upSum += diff
            } else {
                downSum += abs(diff)
            }
        }
        
        // Calculate average gains and losses for the rest of the points
        for i in windowSize..<points.count {
            let diff = points[i].price - points[i - 1].price
            if diff > 0 {
                upSum = (upSum * Double(windowSize - 1) + diff) / Double(windowSize)
                downSum = (downSum * Double(windowSize - 1)) / Double(windowSize)
            } else {
                upSum = (upSum * Double(windowSize - 1)) / Double(windowSize)
                downSum = (downSum * Double(windowSize - 1) + abs(diff)) / Double(windowSize)
            }
            
            let relativeStrength = upSum / downSum
            let rsi = 100 - (100 / (1 + relativeStrength))
            
            array[i] = Point(price: rsi, date: points[i].date)
        }
        
        return array
    }
    static func bollingerBands(points: [Point], windowSize: Int = 20) -> [Point] {
        guard !points.isEmpty && windowSize > 0 else {
            return []
        }

        var bollingerPoints = [Point]()

        for i in 0..<points.count {
            let lowerBound = max(0, i - windowSize + 1)
            let window = points[lowerBound...i]

            let prices = window.map { $0.price }

            let middleBand = prices.reduce(0.0, +) / Double(window.count)
            let squaredDeviations = prices.map { pow($0 - middleBand, 2) }
            let standardDeviation = sqrt(squaredDeviations.reduce(0.0, +) / Double(window.count))

            let upperBand = middleBand + (2 * standardDeviation)
            let lowerBand = middleBand - (2 * standardDeviation)

            // Create new point instances with Bollinger Bands data and original date
            let bollingerPoint = Point(price: middleBand, date: points[i].date)
            let upperBandPoint = Point(price: upperBand, date: points[i].date)
            let lowerBandPoint = Point(price: lowerBand, date: points[i].date)

            // Add new points to the result array
            bollingerPoints.append(bollingerPoint)
            bollingerPoints.append(upperBandPoint)
            bollingerPoints.append(lowerBandPoint)
        }

        return bollingerPoints
    }
}
