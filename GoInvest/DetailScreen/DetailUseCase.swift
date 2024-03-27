import Foundation

protocol DetailUseCase {
    func get(stockItem: StockDisplayItem, parameter: StockState, range: GraphRangeValues, board: String, interval: Int) async throws -> [PricesModel]
}

final class DetailUseCaseImpl: DetailUseCase {

    private let repository: DetailRepository

    public init(repository: DetailRepository) {
        self.repository = repository
    }

    public func get(stockItem: StockDisplayItem, parameter: StockState, range: GraphRangeValues, board: String, interval: Int) async throws -> [PricesModel] {
        try await self.repository.getValues(stockItem: stockItem, parameter: parameter, range: range, board: board, interval: interval)
    }
}
