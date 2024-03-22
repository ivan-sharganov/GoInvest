import Foundation

class NetworkManager{
    
    let shared = NetworkManager()

    
    func TransformPriceData(from initialData: [[Datum]]) -> PricesData {
        var outD = [PricesModel]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        for (_, data) in initialData.enumerated(){
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
    
    func TransformStockData(from initialData: [[Datum]]) -> StockData {
        var outD = [StockModel]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        for (index, data) in initialData.enumerated(){
            var price = StockModel()
            data.forEach({ (element) in
                if case .double(let double) = element {
                    if(index==2){
                        price.close = double
                    }else{
                        price.trendclspr = double
                    }
                }
                if case .string(let string) = element {
                    if(index==0){
                        price.shortName = string
                    }else{
                        price.ticker = string
                    }
                }
            })
            outD.append(price)
        }
        return StockData(data: outD)
    }
    
    
    func getPricesForTicker() {
        let url = "https://iss.moex.com/iss/history/engines/stock/markets/shares/boards/TQBR/securities/YNDX/securities.json?iss.only=securities&from=2024-03-11&till=2024-03-19&interval=2&iss.meta=off&history.columns=CLOSE,VOLUME,TRADEDATE"

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request){ data, response, error in
            DispatchQueue.main.async {
                if let data = data, let answer = try? JSONDecoder().decode(Response.self, from: data){
                    print(self.TransformPriceData(from: answer.history.data)) // передача дальше
                } else {
                    print("NO DATA")
                }
            }
        }.resume()
    }
    
    func getPricesForStock() {
        let url = "https://iss.moex.com/iss/history/engines/stock/markets/shares/sessions/3/securities.json?iss.only=securities&iss.meta=off&history.columns=SHORTNAME,SECID,CLOSE,TRENDCLSPR,BOARDID&limit=20&start=0"

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request){ data, response, error in
            DispatchQueue.main.async {
                if let data = data, let answer = try? JSONDecoder().decode(Response.self, from: data){
                    print(self.TransformStockData(from: answer.history.data)) // передача дальше
                } else {
                    print("NO DATA")
                }
            }
        }.resume()
    }
    
}
