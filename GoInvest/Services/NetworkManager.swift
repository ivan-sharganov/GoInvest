import Foundation

class NetworkManager {
    
    // MARK: - Singleton
    
    static let shared = NetworkManager()
    
    // MARK: - Public methods
    
    /// Получить дату для всех "securities", передаваемы параметры board - тип торгов и ticker - название компаниив
    func getPricesForTicker(
        ticker: String = "YNDX",
        board: String = "TQBR",
        completion: @escaping (PricesData?) -> Void
    ) {
        var url = "https://iss.moex.com/iss/history/engines/stock/markets/shares/boards/\(board)/securities/\(ticker)"
        url += "/securities.json?iss.only=securities&from=2024-03-11&till=2024-03-19&interval=2"
        url += "&iss.meta=off&history.columns=CLOSE,VOLUME,TRADEDATE"

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let answer = try? JSONDecoder().decode(Response.self, from: data) {
                    completion({[weak self] in
                            self?.transformPriceData(from: answer.history.data)}())
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }

    func getPricesForStock(completion: @escaping (StockData?) -> Void) {
        var url = "https://iss.moex.com/iss/history/engines/stock/markets/shares/sessions/3/securities.json?iss"
        url +=
         ".only=securities&iss.meta=off&history.columns=SHORTNAME,SECID,CLOSE,TRENDCLSPR,BOARDID&limit=20&start=0"

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let answer = try? JSONDecoder().decode(Response.self, from: data) {
                    completion({[weak self] in
                        self?.transformStockData(from: answer.history.data)}())
                } else {
                    completion(nil)
                }
            }
        }.resume()
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

        return PricesData(data: outD)
    }

    private func transformStockData(from initialData: [[Datum]]) -> StockData {
        var outD = [StockModel]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        initialData.forEach { (data) in
            var price = StockModel()
            for (index, element) in data.enumerated() {
                if case .double(let double) = element {
                    if index==2 {
                        price.close = double
                    } else {
                        price.trendclspr = double
                    }
                }
                if case .string(let string) = element {
                    if index==0 {
                        price.shortName = string
                    } else if index == 1 {
                        price.ticker = string
                    }
                }
            }
            outD.append(price)
        }

        return StockData(data: outD)
    }
}
