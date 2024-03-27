import Foundation
extension Date {
    func addOrSubtractDay (day: Int) -> Date {
        
        return Calendar.current.date(byAdding: .day, value: day, to: Date())!
    }
}
