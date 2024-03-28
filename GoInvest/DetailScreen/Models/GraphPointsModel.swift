import UIKit

struct PointModels {
    
    var points: [PointModel]
    
    // TODO: проверить что массив всегда не пустой
    var maxY: Double {
        self.points.map { $0.y }.max() ?? Double(Int.max)
    }
    
    var minY: Double {
        self.points.map { $0.y }.min() ?? Double(Int.min)
    }
    
}

struct PointModel: Identifiable {
    
    let x: Date
    let y: Double
    var id: UUID
    
}

enum GraphRangeValues: Int {
    
    case oneDay = 1
    case threeDays = 3
    case week = 7
    case oneMonth = 30
    case threeMonths = 90
    case sixMonths = 180
    case year = 365
    
}
