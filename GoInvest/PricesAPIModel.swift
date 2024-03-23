import Foundation

struct PricesData {

    let data: [PricesModel]

}
struct PricesModel {

    /// Цена закрытия
    var close: Double?

    /// Количество продаж
    var volume: Int?

    /// Дата
    var date: Date?

}

struct Response: Decodable {

    let history: History

}

struct History: Decodable {

    /// Колонки(ключи джейсона)
    let columns: [String]

    /// Дата(массив непонятно чего)
    let data: [[Datum]]

}
enum Datum: Decodable {

    case double(Double)
    case string(String)
    case integer(Int)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .integer(value)
            return
        }
        if let value = try? container.decode(Double.self) {
            self = .double(value)
            return
        }
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        if container.decodeNil() {
               self = .null
               return
        }
        throw DecodingError.typeMismatch(Datum.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Wrong type for Datum"))
    }

}
