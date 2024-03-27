import Foundation
// TODO: - МОКОВАЯ МОДЕЛЬ!!! УДАЛИТЬ КОГДА ПОЯВИТСЯ НОРМ МОДЕЛЬ!!!
struct PetDataMOCK: Identifiable {
    
    var year: Int
    var population: Double
    
    var id: String {
        String(year) + String(population)
    }
    
}
