import Foundation

struct PointsModel{
    
    var points: [PointModel]
    
    let max: Double
    
    let min: Double
    
}

struct PointModel{
    
    let x: Double
    
    let y: Date
    
}

enum GraphRangeValues: Int{
    case oneDay = 1
    case threeDays = 3
    case week = 7
    case oneMonth = 30
    case threeMonths = 90
    case sixMonths = 180
    case year = 9
}
