import Foundation

protocol MainUseCase {
    func get() async -> [StockModel]
}

final class MainUseCaseImpl: MainUseCase {

    private let repository: MainRepository

    public init(repository: MainRepository) {
        self.repository = repository
    }

    public func get() async -> [StockModel] {
        await self.repository.getStocks()
    }
}
