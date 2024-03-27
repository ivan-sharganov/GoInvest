import Foundation

protocol DetailUseCase {
    func get(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int) async throws -> [PricesModel]
}

final class DetailUseCaseImpl: DetailUseCase {

    private let repository: DetailRepository

    public init(repository: DetailRepository) {
        self.repository = repository
    }

    public func get(ticker: String, parameter: StockState, range: GraphRangeValues, interval: Int) async throws -> [PricesModel] {
        try await self.repository.getValues(ticker: ticker, parameter: parameter, range: range, interval: interval)
    }
}
