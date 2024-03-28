import Foundation

final class CachingClass {
    static let shared = CachingClass()
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveCache(records: StockData, key: String) {
        let fileName = "CacheFile" + key
        /// Задаем путь к файлы с кэшем
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        do {
            /// Архивируем дату
            let archiver = NSKeyedArchiver(requiringSecureCoding: false)
            archiver.outputFormat = .binary
            try archiver.encodeEncodable(records, forKey: key)
            archiver.finishEncoding()
            /// Пробуем записать дату в файл по URL
            try archiver.encodedData.write(to: filePath)
        } catch let error {
            print("Failed to save cache: ", error.localizedDescription)
        }
    }
    
    func getCache(for key: String) -> StockData? {
        let fileName = "CacheFile" + key
        let filePath = self.getDocumentDirectory().appendingPathComponent(fileName)
        
        guard let data = try? Data(contentsOf: filePath) else {
            print("Failed to get  cache")
            
            return nil
        }
        
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            let cachedData = unarchiver.decodeDecodable(StockData.self, forKey: key)
            
            return cachedData
        } catch let error {
            print("Failed to get cache: ", error.localizedDescription)
            
            return nil
        }
    }
    
}
