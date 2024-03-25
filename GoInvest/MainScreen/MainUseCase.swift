import Foundation

protocol MainUseCase {
    func get() async throws -> [StockModel]
}

final class MainUseCaseImpl: MainUseCase {

    private let repository: MainRepository

    public init(repository: MainRepository) {
        self.repository = repository
    }

    public func get() async throws -> [StockModel] {
        try await self.repository.getStocks()
    }
}
