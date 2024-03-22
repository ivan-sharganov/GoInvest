//
//  MainViewModel.swift
//  GoInvest
//
//  Created by Кирилл Бережной on 22.03.2024.
//

import Foundation

protocol MainViewModel {
    
    var displayItems: [StockModel] { get }
    
}

final class MainViewModelImpl: MainViewModel {
    
    // MARK: - Public properties
    
    var displayItems: [StockModel] = [StockModel(shortName: "ExampleShortName", ticker: "ExampleTicket", close: 5.5, trendclspr: 5.5), StockModel(shortName: "AnotherExampleShortName", ticker: "ExampleTicket", close: 5.5, trendclspr: 5.5), StockModel(shortName: "FuckCI", ticker: "ExampleTicket", close: 5.5, trendclspr: 5.5)]
    
    // MARK: - Private properties
    
    let useCase: MainUseCase
    
    // MARK: - Life cycle
    
    init(useCase: MainUseCase) {
        self.useCase = useCase
    }
    
}
