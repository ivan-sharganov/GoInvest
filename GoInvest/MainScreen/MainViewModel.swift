import Foundation
import RxSwift
import RxCocoa

protocol MainViewModel {

    var cellTapped: PublishRelay<Void> { get }

    var displayItems: [StockModel] { get }
    
    var responseItems: [StockModel] { get }

    func handleItemSelection()
    func fetchData() async
    func searchItems(for query: String?)

}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Public properties

    let cellTapped = PublishRelay<Void>()

    var displayItems: [StockModel] = []
    
    var responseItems: [StockModel] = []

    // MARK: - Private properties

    let useCase: MainUseCase

    // MARK: - Life cycle

    init(useCase: MainUseCase) {
        self.useCase = useCase
    }

    // MARK: - Public methods

    func handleItemSelection() {
        cellTapped.accept(())
    }
    
    func searchItems(for query: String?) {
        guard let query else {
            self.displayItems = self.responseItems
            
            return
        }
        
        if query.isEmpty {
            self.displayItems = self.responseItems
        } else {
            self.displayItems = self.responseItems.filter { $0.shortName?.contains(query) ?? false }
        }
    }

    // MARK: - Private methods

    // сделать енум параметров (индексы, фьючерсы и тд)
    public func fetchData() async {
        do {
            self.responseItems = try await self.useCase.get()
            self.displayItems = responseItems
        } catch {
            self.responseItems = []
        }
    }
}
