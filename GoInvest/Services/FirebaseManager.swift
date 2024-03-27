import FirebaseFirestore
import FirebaseAuth

enum FirebaseError: Error {
    case noCurrentUser
}

final class FirebaseManager {
    
    private enum Fields: String {
        case name
        case shortName
        case openPrice
        case closePrice
        case highPrice
        case lowPrice
        case rate
    }
    
    // MARK: - Singletone
    
    static let shared = FirebaseManager()
    
    // MARK: Private properties
    
    private let database = Firestore.firestore()
    private var pathToUser: String {
        get throws {
            guard let currentUserId = FirebaseAuth.Auth.auth().currentUser?.uid else {
                throw FirebaseError.noCurrentUser
            }
            return "users/\(currentUserId)/"
        }
    }
    
    // MARK: Init
    
    private init() {}
    
    // MARK: - Public methods
    
    func addItems(_ items: [StockDisplayItem]) {
        
        items.forEach { item in
            if let name = item.name,
               let shortName = item.shortName,
               let openPrice = item.openPrice,
               let closePrice = item.closePrice,
               let highPrice = item.highPrice,
               let lowPrice = item.lowPrice,
               let rate = item.rate 
            {
                
            }
        }
    }
    
    
    // MARK: - Private methods
    
    private func referenceToItem(shortName: String) throws -> DocumentReference {
        let reference = try database.document(pathToUser + shortName)
        
        return reference
    }
}
