import Foundation

final class CachingClass {
    static let shared = CachingClass()
    let filePrefix = "GoInvestCache"
    func getDocumentDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
    
    func saveCache(records: StockData, key: String) {
        let fileName = filePrefix + key
        /// Задаем путь к файлы с кэшем
        guard let filePath = self.getDocumentDirectory()?.appendingPathComponent(fileName) else {
            return
        }
            
        do {
            /// Архивируем дату
            let archiver = NSKeyedArchiver(requiringSecureCoding: false)
            archiver.outputFormat = .binary
            try archiver.encodeEncodable(records, forKey: key)
            archiver.finishEncoding()
            /// Пробуем записать дату в файл по URL
            try archiver.encodedData.write(to: filePath)
        } catch let error {
            print("Failed to save cache: ", error.localizedDescription) // TODO: обработать ошибку в UI
        }
    }
    
    func getCache(for key: String) -> StockData? {
        let fileName = filePrefix + key
        guard let filePath = self.getDocumentDirectory()?.appendingPathComponent(fileName) else {
            return nil
        }
        guard let data = try? Data(contentsOf: filePath) else {
            print("Failed to get  cache") // TODO: Обработать ошибку в UI
            
            return nil
        }
        
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            let cachedData = unarchiver.decodeDecodable(StockData.self, forKey: key)
            
            return cachedData
        } catch let error {
            print("Failed to get cache: ", error.localizedDescription) // TODO: обработать ошибку в UI
            
            return nil
        }
    }
    
}
