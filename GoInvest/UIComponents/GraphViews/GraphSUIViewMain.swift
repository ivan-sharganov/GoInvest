import SwiftUI
import Charts

struct GraphSUIViewMain: View {
    
    let pointsData: [PointModel]
    let maxY: Double
    let minY: Double
    
    init(pointsData: PointModels) {
        self.pointsData = pointsData.points
        self.maxY = pointsData.maxY
        self.minY = pointsData.minY
    }
    
    var data: [(type: String, pointsData: [PointModel])] {
        [(type: "", pointsData: pointsData)]
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
//        .chartYScale(domain: minY...maxY)
        .cornerRadius(15)
        .edgesIgnoringSafeArea(.all)
    }
    
}
