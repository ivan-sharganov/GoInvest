import Foundation

protocol DetailUseCase {
    func get(stockItem: StockDisplayItem) async throws -> [PricesModel]
}

final class DetailUseCaseImpl: DetailUseCase {

    private let repository: DetailRepository

    public init(repository: DetailRepository) {
        self.repository = repository
    }

    public func get(stockItem: StockDisplayItem) async throws -> [PricesModel] {
        try await self.repository.getValues(stockItem: stockItem)
    }
}
