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
            (type: "", pointsData: pointsData),
            (type: "agr", pointsData: agregatedPointsData),
        ]
    }
    
    var body: some View {
        Chart(data, id: \.type) { dataSeries in
            ForEach(dataSeries.pointsData) { data in
                LineMark(x: .value("Date", data.x),
                         y: .value("Result", data.y))
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
