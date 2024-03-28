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
            return "users/\(currentUserId)/items/"
        }
    }
    
    // MARK: Init
    
    private init() {}
    
    // MARK: - Public methods
    
    func addItems(_ items: [StockDisplayItem]) {
        items.forEach { item in
            let reference = referenceToItem(shortName: item.shortName)
            let documentData: [String: Any] = [
                "name": item.name,
                "shortName": item.shortName,
                "openPrice": item.openPrice,
                "closePrice": item.closePrice,
                "highPrice": item.highPrice,
                "lowPrice": item.lowPrice,
                "rate": item.rate
            ]
            reference?.setData(documentData)
        }
    }

    // MARK: - Private methods

    private func referenceToItem(shortName: String) -> DocumentReference? {
        var reference: DocumentReference?
        do {
            reference = try database.document(pathToUser + shortName)
        } catch {
            print(error.localizedDescription)
        }
        
        return reference
    }
}
