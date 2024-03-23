import Foundation
import RxSwift
import RxCocoa

protocol MainViewModel {
    
    var cellTapped: PublishRelay<Void> { get }

    var displayItems: [StockModel] { get }
    
    func handleItemSelection()

}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Public properties
    
    let cellTapped = PublishRelay<Void>()

    var displayItems: [StockModel] = [
        StockModel(shortName: "ExampleShortName", ticker: "ExampleTicket", close: 5.5, trendclspr: 5.5),
        StockModel(shortName: "AnotherExampleShortName", ticker: "ExampleTicket", close: 5.5, trendclspr: 5.5),
        StockModel(shortName: "FuckCI", ticker: "ExampleTicket", close: 5.5, trendclspr: 5.5)
    ]

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

}
