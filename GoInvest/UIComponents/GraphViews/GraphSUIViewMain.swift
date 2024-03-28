import SwiftUI
import Charts

struct GraphSUIViewMain: View {
    
    let catData: [PetDataMOCK] = [PetDataMOCK(year: 2000, population: 6.8),
                                  PetDataMOCK(year: 2010, population: 8.2),
                                  PetDataMOCK(year: 2015, population: 12.9),
                                  PetDataMOCK(year: 2022, population: 15.2)]
    
    var data: [(type: String, petData: [PetDataMOCK])] {
        [(type: "", petData: catData)]
    }
    
    var body: some View {
        Chart(data, id: \.type) { dataSeries in
            ForEach(dataSeries.petData) { data in
                LineMark(x: .value("Year", data.year),
                         y: .value("Population", data.population))
            }
            .symbol(by: .value("Pet type", dataSeries.type))
        }
        .chartBackground { _ in
            Color(UIColor.offTabBackground)
        }
        .chartXAxis { AxisMarks(stroke: StrokeStyle(lineWidth: 0)) } // AxisGridLine() AxisTick()
        .chartYAxis { AxisMarks(stroke: StrokeStyle(lineWidth: 0)) } // AxisGridLine() AxisTick()
        .chartXScale(domain: 1998...2031)
        .chartYScale(domain: 0...30)
        .cornerRadius(15)
        .edgesIgnoringSafeArea(.all)
    }
    
}
