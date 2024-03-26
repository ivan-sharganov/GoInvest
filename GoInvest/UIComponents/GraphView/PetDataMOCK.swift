//
//  PetDataMOCK.swift
//  GoInvest
//
//  Created by Кирилл Бережной on 26.03.2024.
//

import Foundation
// TODO: - МОКОВАЯ МОДЕЛЬ!!! УДАЛИТЬ КОГДА ПОЯВИТСЯ НОРМ МОДЕЛЬ!!!
struct PetDataMOCK: Identifiable {
    
    var year: Int
    var population: Double
    
    var id: String {
        String(year) + String(population)
    }
    
}
