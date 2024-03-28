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

enum GraphRangeValues: Int, CaseIterable {
    
    case oneDay = 1
    case threeDays = 3
    case week = 7
    case oneMonth = 30
    case threeMonths = 90
    case sixMonths = 180
    case year = 365
    
    var stringValue: String {
        switch self {
        case .oneDay:
            return "1" + NSLocalizedString("day", comment: "")
        case .threeDays:
            return "3" + NSLocalizedString("day", comment: "")
        case .week:
            return "7" + NSLocalizedString("day", comment: "")
        case .oneMonth:
            return "1" + NSLocalizedString("month", comment: "")
        case .threeMonths:
            return "3" + NSLocalizedString("month", comment: "")
        case .sixMonths:
            return "6" + NSLocalizedString("month", comment: "")
        case .year:
            return "1" + NSLocalizedString("year", comment: "")
        }
    }
    
}

enum MathFunctions: String, CaseIterable {
    case SMA
    case EMA
    case RSI
}
