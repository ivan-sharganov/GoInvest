import Foundation

struct PointsModel {
    
    var points: [PointModel]
    
    // TODO: проверить что массив всегда не пустой
    var max: Double {
        self.points.map { $0.y }.max()! //  ?? Double(Int.max)
    }
    
    var min: Double {
        self.points.map { $0.y }.min()! // ?? Double(Int.min)
    }
    
}

struct PointModel {
    
    let x: Date
    
    let y: Double
    
}

enum GraphRangeValues: Int, CaseIterable {
    
    case oneDay = 1
    case threeDays = 3
    case week = 7
    case oneMonth = 30
    case threeMonths = 90
    case sixMonths = 180
    case year = 365
    
}
