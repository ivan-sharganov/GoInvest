import Foundation

class NetworkManager {
    
    private enum NetworkConstants {
        static let responseItemsCount: Int = 20
    }
    private enum GIError: Error {
        case error
    }
    
    // MARK: - Singleton
    
    static let shared = NetworkManager()
    
    // MARK: - Public methods
    
//    func getPricesForTicker(
//        ticker: String = "YNDX",
//        board: String = "TQBR",
//        completion: @escaping (PricesData?) -> Void
//    ) {
//        var url = "https://iss.moex.com/iss/history/engines/stock/markets/shares/boards/\(board)/securities/\(ticker)"
//        url += "/securities.json?iss.only=securities&from=2024-03-11&till=2024-03-19&interval=2"
//        url += "&iss.meta=off&history.columns=CLOSE,VOLUME,TRADEDATE"
//        
//        var request = URLRequest(url: URL(string: url)!)
//        request.httpMethod = "GET"
//        
//        URLSession.shared.dataTask(with: request) { data, _, _ in
//            DispatchQueue.main.async {
//                if let data = data, let answer = try? JSONDecoder().decode(Response.self, from: data) {
//                    completion({[weak self] in
//                        self?.transformPriceData(from: answer.history.data)}())
//                } else {
//                    completion(nil)
//                }
//            }
//        }.resume()
//    }
    
    /// parameter = shares
    /// board = TQBR
    
    func getPricesForTicker(parameter: String, board: String, ticker: String, from: String, till: String, interval: Int) async throws -> [PricesModel] {
        var url = "https://iss.moex.com/iss/history/engines/stock/markets/\(parameter)/\(board)/securities/\(ticker)/securities.json?iss"
        url +=
        ".only=securities&iss.meta=off&from=\(from)&till=\(till)&interval=\(interval)"
        url += "&iss.meta=off&history.columns=CLOSE,VOLUME,TRADEDATE"
        
        guard let URL = URL(string: url) else {
            throw GIError.error
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let answer = try? JSONDecoder().decode(Response.self, from: data) else {
            throw GIError.error
        }
        
        return self.transformPriceData(from: answer.history.data).pricesModel.filter {
            $0.close != nil &&
            $0.date != nil &&
            $0.volume != nil
//            $0.shortName != nil &&
//            $0.ticker != nil &&
//            $0.open != nil &&
//            $0.close != nil &&
//            $0.high != nil &&
//            $0.low != nil
        }
    }
    
    func getPricesForStock(parameter: String) async throws -> [StockModel] {
        print("CALLED")
        var url = "https://iss.moex.com/iss/history/engines/stock/markets/\(parameter)/sessions/3/securities.json?iss"
        url +=
        ".only=securities&iss.meta=off&history.columns=SHORTNAME,SECID,OPEN,CLOSE,HIGH,LOW,BOARDID&limit=100&start=0"
        
        guard let URL = URL(string: url) else {
            throw GIError.error
        }
        
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
            $0.boardID != nil
        }
    }
    
    // MARK: - Private methods
    
    private func transformPriceData(from initialData: [[Datum]]) -> PricesData {
        var outD = [PricesModel]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        for data in initialData {
            var price = PricesModel()
            data.forEach({ (element) in
                if case .integer(let integer) = element {
                    price.volume = integer
                }
                if case .double(let double) = element {
                    price.close = double
                }
                if case .string(let string) = element {
                    price.date = dateFormatter.date(from: string)
                }
                
            })
            outD.append(price)
        }
        print(outD)
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
                    if index == 2 {
                        price.open = double
                    } else if index == 3 {
                        price.close = double
                    } else if index == 4 {
                        price.high = double
                    } else if index == 5 {
                        price.low = double
                    }
                }
                if case .string(let string) = element {
                    if index == 0 {
                        price.shortName = string
                    } else if index == 1 {
                        price.ticker = string
                    } else if index == 6 {
                        price.boardID = string
                    }
                }
            }
            outD.append(price)
        }
        
        return StockData(stocksModels: outD)
    }
    
}
