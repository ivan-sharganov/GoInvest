import SwiftUI
import Charts

struct GraphSUIViewMain: View {
    
    @State var pointsData: [PointModel]
    @State var agregatedPointsData: [PointModel] = []
    var maxY: Double
    var minY: Double
    
    init(pointsData: [PointModel], agregatedPointsData: [PointModel]) {
        self.pointsData = pointsData
        self.agregatedPointsData = agregatedPointsData
        // TODO: какие дефолтные?
        self.maxY = pointsData.map { $0.y }.max() ?? 0
        self.minY = pointsData.map { $0.y }.min() ?? 0
    }
    
    var data: [(type: String, pointsData: [PointModel])] {
        [
            // (type: "", pointsData: pointsData),
            (type: "a", pointsData: agregatedPointsData),
        ]
    }
    
    var body: some View {
        Chart(data, id: \.type) { dataSeries in
            ForEach(pointsData) { data in
                LineMark(x: .value("Date", data.x),
                         y: .value("Result", data.y)).foregroundStyle(.red)
            }
//            .symbol(by: .value("Pet type", dataSeries.type))

            ForEach(agregatedPointsData) { data in
                LineMark(x: .value("Date", data.x),
                         y: .value("Result", data.y))
                .foregroundStyle(.blue)
            }
            .symbol(by: .value("Pet type", dataSeries.type))
        }
        .chartBackground { _ in
            Color(UIColor.offTabBackground)
        }
        .chartXAxis { AxisMarks(stroke: StrokeStyle(lineWidth: 0)) } // AxisGridLine() AxisTick()
        .chartYAxis { AxisMarks(stroke: StrokeStyle(lineWidth: 0)) } // AxisGridLine() AxisTick()
//        .chartXScale(domain: 1998...2031)
        .chartYScale(domain: minY...maxY)
        .cornerRadius(15)
        .edgesIgnoringSafeArea(.all)
    }
    
}
//
// struct SwiftUdddIViewAdditional: View {
//    let catData: [PetDataMOCK] = [PetDataMOCK(year: 2000, population: 6.8),
//                                  PetDataMOCK(year: 2010, population: 8.2),
//                                  PetDataMOCK(year: 2015, population: 12.9),
//                                  PetDataMOCK(year: 2022, population: 15.2)]
//    
//    var data: [(type: String, petData: [PetDataMOCK])] {
//        [(type: "cat", petData: catData)]
//    }
//    
//    var body: some View {
//        Chart(data, id: \.type) { dataSeries in
//            ForEach(dataSeries.petData) { data in
//                LineMark(x: .value("Year", data.year),
//                         y: .value("Population", data.population))
//            }
//            .foregroundStyle(by: .value("Pet type", dataSeries.type))
//        }
//        .chartXScale(domain: 1998...2031)
//        .chartYScale(domain: 0...30)
//        .edgesIgnoringSafeArea(.all)
//    }
// }
