import Foundation

class NetworkManager {
    
    private enum NetworkConstants {
        static let responseItemsCount: Int = 20
    }
    private enum GIError: Error {
        case error
    }
    private let baseURL = "https://iss.moex.com/iss/history/engines/stock/markets/"
    private let columnsForTicker = "&iss.meta=off&candles.columns=close,volume,end"
    private let candles = "/candles.json?iss.only=securities&"
    private let sessions = "/sessions/3/securities.json?iss.only=securities&iss.meta=off"
    private let columnsForStock = "&history.columns=SHORTNAME,SECID,OPEN,CLOSE,HIGH,LOW,BOARDID&limit=100"
    // MARK: - Singleton
    
    static let shared = NetworkManager()
    
    // MARK: - Public methods
    
    func getPricesForTicker(
        parameter: String,
        ticker: String,
        from: String,
        till: String,
        interval: Int
    ) async throws -> [PricesModel] {
        let url = self.baseURL + parameter + "/securities/\(ticker)" + self.candles + "from=\(from)&till=\(till)" + self.columnsForTicker
        
        guard let URL = URL(string: url) else {
            throw GIError.error
        }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let answer = try? JSONDecoder().decode(ResponseCandles.self, from: data) else {
            throw GIError.error
        }
        
        return self.transformPriceData(from: answer.candles.data).pricesModel.filter {
            $0.close != nil &&
            $0.date != nil &&
            $0.volume != nil
        }
    }
    
    func getPricesForStock(parameter: String) async throws -> [StockModel] {
        let url = self.baseURL + parameter + self.sessions + self.columnsForStock
        
        guard let URL = URL(string: url) else {
            throw GIError.error
        }
        print(url)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let answer = try? JSONDecoder().decode(Response.self, from: data) else {
            throw GIError.error
        }
        
        return self.transformStockData(from: answer.history.data).stocksModels.filter {
            $0.shortName != nil &&
            $0.ticker != nil &&
            $0.open != nil &&
            $0.close != nil &&
            $0.high != nil &&
            $0.low != nil &&
            $0.boardID != nil &&
            $0.open != $0.close &&
            $0.high != $0.low
        }
    }
    
    // MARK: - Private methods
    
    private func transformPriceData(from initialData: [[Datum]]) -> PricesData {
        var outD = [PricesModel]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyy-MM-dd HH:mm:ss"
        for data in initialData {
            var price = PricesModel()
            for (index, element) in data.enumerated() {
                if case .double(let double) = element {
                    switch index {
                    case 0:
                        price.close = double
                    case 1:
                        price.volume = double
                    default:
                        continue
                    }
                }
                if case .integer(let int) = element {
                    switch index {
                    case 0:
                        price.close = Double(int)
                    case 1:
                        price.volume = Double(int)
                    default:
                        continue
                    }
                }
                if case .string(let string) = element {
                    price.date = dateFormatter.date(from: string)
                }
                
            }
            outD.append(price)
        }
        
        return PricesData(pricesModel: outD)
    }
    
    private func transformStockData(from initialData: [[Datum]]) -> StockData {
        var outD = [StockModel]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        initialData.forEach { (data) in
            var price = StockModel()
            for (index, element) in data.enumerated() {
                if case .double(let double) = element {
                    switch index {
                    case 2:
                        price.open = double
                    case 3:
                        price.close = double
                    case 4:
                        price.high = double
                    case 5:
                        price.low = double
                    default:
                        continue
                    }
                }
                if case .string(let string) = element {
                    switch index {
                    case 0:
                        price.shortName = string
                    case 1:
                        price.ticker = string
                    case 6:
                        price.boardID = string
                    default:
                        continue
                    }
                }
            }
            outD.append(price)
        }
        
        return StockData(stocksModels: outD)
    }
    
}
