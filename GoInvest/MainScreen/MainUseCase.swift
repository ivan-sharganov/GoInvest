import Foundation

protocol MainUseCase {
    func get(parameters: StockState) async throws -> [StockModel]
}

final class MainUseCaseImpl: MainUseCase {

    private let repository: MainRepository

    public init(repository: MainRepository) {
        self.repository = repository
    }

    public func get(parameters: StockState) async throws -> [StockModel] {
        let response = try await self.repository.getStocks(parameters: parameters)
        return response
    }
}
