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
        case boardID
        case isFavourite
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
    
    func getItems() -> [StockDisplayItem] {
//        let shortNames = referenceToItems()?.getDocuments(completion: { snapshot, error in
//            if error == nil {
//                snapshot?.documents.first?.data()
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
        []
    }
    
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
                "boardID": item.boardID,
                "isFavourite": item.isFavourite,
                "rate": item.rate
            ]
            reference?.setData(documentData)
        }
    }

    // MARK: - Private methods
    
    private func referenceToItems() -> CollectionReference? {
        var reference: CollectionReference?
        do {
            reference = try database.collection(pathToUser + "items")
        } catch {
            print(error.localizedDescription)
        }
        
        return reference
    }

    private func referenceToItem(shortName: String) -> DocumentReference? {
        var reference: DocumentReference?
        do {
            reference = try database.document(pathToUser +  "items/" + shortName)
        } catch {
            print(error.localizedDescription)
        }
        
        return reference
    }
    
    func getItem(shortName: String, completion: @escaping (Result<StockDisplayItem, any Error>) -> Void) {
        let reference = referenceToItem(shortName: shortName)
        reference?.getDocument(as: StockDisplayItem.self, completion: completion)
    }
}
