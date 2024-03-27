import Foundation

extension Date {
    
    func addOrSubtractDay(day: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date.now
    }
    
}
