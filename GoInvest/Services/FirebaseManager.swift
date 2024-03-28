import FirebaseFirestore
import FirebaseAuth

enum FirebaseError: Error {
    case noCurrentUser
    case getSnapshotError
}

 // TODO: Add check login method

final class FirebaseManager {
    
    enum ItemKind {
        case bought
        case favorite
    }
    
    private enum Fields: String {
        case name
        case shortName
        case openPrice
        case closePrice
        case highPrice
        case lowPrice
        case boardID
        case isFavorite
        case rate
    }
    
    // MARK: - Singletone
    
    static let shared = FirebaseManager()
    
    // MARK: - Public properties
    
    var isLogin: Bool {
        FirebaseAuth.Auth.auth().currentUser != nil
    }
    
    // MARK: Private properties
    
    private let database = Firestore.firestore()
    private var pathToFavorites: String {
        get throws {
            guard let currentUserId = FirebaseAuth.Auth.auth().currentUser?.uid else {
                throw FirebaseError.noCurrentUser
            }
            return "favorites/\(currentUserId)/"
        }
    }
    private var pathToBought: String {
        get throws {
            guard let currentUserId = FirebaseAuth.Auth.auth().currentUser?.uid else {
                throw FirebaseError.noCurrentUser
            }
            return "bought/\(currentUserId)/"
        }
    }
    
    // MARK: Init
    
    private init() {}
    
    // MARK: - Public methods
    
    /// Asks firestore for collection of StockDisplayItem's for current user.
    func getItems(kind: ItemKind, completition: @escaping (Result<[StockDisplayItem], any Error>) -> Void) {
        referenceToItems(kind: kind)?.getDocuments { snapshot, error in
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

    func addItems(_ items: [StockDisplayItem], kind: ItemKind) {
        items.forEach { item in
            let reference = referenceToItem(shortName: item.shortName, kind: kind)
            let documentData: [String: Any] = [
                Fields.name.rawValue: item.name,
                Fields.shortName.rawValue: item.shortName,
                Fields.openPrice.rawValue: item.openPrice,
                Fields.closePrice.rawValue: item.closePrice,
                Fields.highPrice.rawValue: item.highPrice,
                Fields.lowPrice.rawValue: item.lowPrice,
                Fields.boardID.rawValue: item.boardID,
                Fields.isFavorite.rawValue: item.isFavorite,
            ]
            reference?.setData(documentData)
        }
    }
    
    /// Asks firestore for SINGLE item specified by it's shortName for current user
    func getItem(shortName: String, kind: ItemKind, completion: @escaping (Result<StockDisplayItem, any Error>) -> Void) {
        let reference = referenceToItem(shortName: shortName, kind: kind)
        reference?.getDocument(as: StockDisplayItem.self, completion: completion)
    }

    // MARK: - Private methods
    
    private func referenceToItems(kind: ItemKind) -> CollectionReference? {
        var reference: CollectionReference?
        do {
            switch kind {
            case .favorite:
                reference = try database.collection(pathToFavorites + "items")
            case .bought:
                reference = try database.collection(pathToBought + "items")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return reference
    }

    private func referenceToItem(shortName: String, kind: ItemKind) -> DocumentReference? {
        var reference: DocumentReference?
        do {
            switch kind {
            case .favorite:
                reference = try database.document(pathToFavorites +  "items/" + shortName)
            case .bought:
                reference = try database.document(pathToBought +  "items/" + shortName)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return reference
    }
    
}
