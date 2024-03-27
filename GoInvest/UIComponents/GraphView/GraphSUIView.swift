//
//  GraphSUIView.swift
//  GoInvest
//
//  Created by Кирилл Бережной on 26.03.2024.
//

import SwiftUI
import Charts

struct GraphSUIView: View {
    
    let catData: [PetDataMOCK] = [PetDataMOCK(year: 2000, population: 6.8),
                                  PetDataMOCK(year: 2010, population: 8.2),
                                  PetDataMOCK(year: 2015, population: 12.9),
                                  PetDataMOCK(year: 2022, population: 15.2)]
    let dogData: [PetDataMOCK] = [PetDataMOCK(year: 2000, population: 5),
                                  PetDataMOCK(year: 2010, population: 5.3),
                                  PetDataMOCK(year: 2015, population: 7.9),
                                  PetDataMOCK(year: 2022, population: 10.6)]
    let capybaraData: [PetDataMOCK] = [PetDataMOCK(year: 2002, population: 9),
                                       PetDataMOCK(year: 2007, population: 2),
                                       PetDataMOCK(year: 2010, population: 17),
                                       PetDataMOCK(year: 2025, population: 24)]
    
    var data: [(type: String, petData: [PetDataMOCK])] {
        [(type: "cat", petData: catData),
         (type: "dog", petData: dogData),
         (type: "capybara", petData: capybaraData)]
    }
    
    var body: some View {
        Chart(data, id: \.type) { dataSeries in
            ForEach(dataSeries.petData) { data in
                LineMark(x: .value("Year", data.year),
                         y: .value("Population", data.population))
            }
            .foregroundStyle(by: .value("Pet type", dataSeries.type))
            .symbol(by: .value("Pet type", dataSeries.type))
        }
        .chartXScale(domain: 1998...2031)
        .chartYScale(domain: 0...30)
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
    
}
