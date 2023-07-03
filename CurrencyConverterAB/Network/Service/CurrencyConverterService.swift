//
//  CurrencyConverterService.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation

struct CurrencyConverterService {
    
    private let manager = NetworkManager()
    
    func getSymbols(completion: @escaping (Result<Symbols, Error>) -> Void) {
        let route = CurrencyRouter.symbols
        manager.sendRequest(target: route, completion: completion)
    }
    
    func getRates(base: String, symbols: String, completion: @escaping (Result<RatesModel, Error>) -> Void) {
        let route = CurrencyRouter.latestCurrency(base: base, symbols: symbols)
        manager.sendRequest(target: route, completion: completion)
    }
}
