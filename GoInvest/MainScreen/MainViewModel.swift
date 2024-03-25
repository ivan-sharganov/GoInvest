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
        StockModel(shortName: "Longlonglongname", ticker: "LONGLONGNAME", close: 50.25, trendclspr: 5.5),
        StockModel(shortName: "Company", ticker: "CSLS", close: 5124.5, trendclspr: -125.5),
        StockModel(shortName: "FuckCI", ticker: "FUCKCI", close: 1234.5, trendclspr: 125.35),
        StockModel(shortName: "Dadadada", ticker: "DDDD", close: 135.5, trendclspr: -5.5),
        StockModel(shortName: "Yandex, LCC", ticker: "YNDX", close: 12225.5, trendclspr: 25.55),
        StockModel(shortName: "Ahahah", ticker: "AHAHAH", close: 5123.5, trendclspr: 5.65),
        StockModel(shortName: "2Longlonglongname", ticker: "LONGLONGNAME", close: 50.25, trendclspr: 5.5),
        StockModel(shortName: "2Company", ticker: "CSLS", close: 5124.5, trendclspr: -125.5),
        StockModel(shortName: "2FuckCI", ticker: "FUCKCI", close: 1234.5, trendclspr: 125.35),
        StockModel(shortName: "2Dadadada", ticker: "DDDD", close: 135.5, trendclspr: -5.5),
        StockModel(shortName: "2Yandex, LCC", ticker: "YNDX", close: 12225.5, trendclspr: 25.55),
        StockModel(shortName: "2Ahahah", ticker: "AHAHAH", close: 5123.5, trendclspr: 5.65),
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
