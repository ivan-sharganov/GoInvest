import Foundation

protocol DetailViewModel {
    
}

class DetailViewModelImpl: DetailViewModel {
    
    var pointsModel: PointsModel?
    
    func transformPricesToPointModels ( data: [PricesModel], range: Int = 0 ) -> PointsModel {
        var max = Double(Int.min)
        var min = Double(Int.max)
        var pointsModel = PointsModel(points: [], max: max, min: min)
        for i in data {
            guard let x = i.close, let y = i.date else {
                continue
            }
            pointsModel.points.append(PointModel(x: x, y: y))
            if x > max {
                max = x
            } else if x < min {
                min = x
            }
        }
        
        return pointsModel
    }
    
}
