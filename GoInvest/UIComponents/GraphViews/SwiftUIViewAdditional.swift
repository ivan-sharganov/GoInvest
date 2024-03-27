import SwiftUI
import Charts

struct SwiftUIViewAdditional: View {
    let catData: [PetDataMOCK] = [PetDataMOCK(year: 2000, population: 6.8),
                                  PetDataMOCK(year: 2010, population: 8.2),
                                  PetDataMOCK(year: 2015, population: 12.9),
                                  PetDataMOCK(year: 2022, population: 15.2)]
    
    var data: [(type: String, petData: [PetDataMOCK])] {
        [(type: "cat", petData: catData)]
    }
    
    var body: some View {
        Chart(data, id: \.type) { dataSeries in
            ForEach(dataSeries.petData) { data in
                LineMark(x: .value("Year", data.year),
                         y: .value("Population", data.population))
            }
//            .foregroundStyle(by: .value("Pet type", dataSeries.type))
        }
        .chartXScale(domain: 1998...2031)
        .chartYScale(domain: 0...30)
        .edgesIgnoringSafeArea(.all)
    }
}
