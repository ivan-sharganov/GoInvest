import FirebaseFirestore
import FirebaseAuth

enum FirebaseError: Error {
    case noCurrentUser
    case getSnapshotError
}

 // TODO: Add check login method

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
    
    /// Asks firestore for collection of StockDisplayItem's for current user.
    func getItems(completition: @escaping (Result<[StockDisplayItem], any Error>) -> Void) {
        referenceToItems()?.getDocuments { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                completition(Result.failure(error ?? FirebaseError.getSnapshotError))
                return
            }
            
            var items: [StockDisplayItem] = []
            do {
                items = try snapshot.documents.compactMap {
                    let data = $0.data()
                    let item = try Firestore.Decoder.init().decode(StockDisplayItem.self, from: data)
                    return item
                }
            } catch {
                completition(Result.failure(error))
            }
            
            completition(Result.success(items))
        }
    }

    func addItems(_ items: [StockDisplayItem]) {
        items.forEach { item in
            let reference = referenceToItem(shortName: item.shortName)
            let documentData: [String: Any] = [
                Fields.name.rawValue: item.name,
                Fields.shortName.rawValue: item.shortName,
                Fields.openPrice.rawValue: item.openPrice,
                Fields.closePrice.rawValue: item.closePrice,
                Fields.highPrice.rawValue: item.highPrice,
                Fields.lowPrice.rawValue: item.lowPrice,
                Fields.boardID.rawValue: item.boardID,
                Fields.isFavourite.rawValue: item.isFavourite,
                Fields.rate.rawValue: item.rate
            ]
            reference?.setData(documentData)
        }
    }
    
    /// Asks firestore for SINGLE item specified by it's shortName for current user
    func getItem(shortName: String, completion: @escaping (Result<StockDisplayItem, any Error>) -> Void) {
        let reference = referenceToItem(shortName: shortName)
        reference?.getDocument(as: StockDisplayItem.self, completion: completion)
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
}
