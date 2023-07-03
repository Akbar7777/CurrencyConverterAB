//
//  CurrencyViewModel.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation
import RxCocoa
import RxSwift

class CurrencyViewModel {
    
    let fromCurrencyInput = BehaviorRelay<String>(value: "")
    let toCurrencyInput = BehaviorRelay<String>(value: "")
    
    let selectedFromCurrency = BehaviorRelay<String?>(value: "EUR")
    let selectedToCurrency = BehaviorRelay<String?>(value: nil)
    
    let currencyList = BehaviorRelay<[String]?>(value: nil)
    
    let error = BehaviorRelay<String?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    private let service = CurrencyConverterService()
    
    let disposeBag = DisposeBag()
    
    
    func getSymbols() {
        self.isLoading.accept(true)
        service.getSymbols { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(symbols):
                let list = symbols.symbols?.keys.map { String($0) }
                self.currencyList.accept(list)
            case let .failure(error):
                self.handleError(error: error)
            }
            self.isLoading.accept(false)
        }
    }
    
    func updateRates() {
        guard let base = selectedFromCurrency.value,
              let symbols = selectedToCurrency.value
        else { return }
        self.isLoading.accept(true)
        service.getRates(base: base, symbols: symbols) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(rates):
                if let value = Double(self.fromCurrencyInput.value),
                   let rate = rates.rates?[symbols] {
                    let amount = (rate ?? 0) * value
                    self.toCurrencyInput.accept(String(amount).formatCurrency(shouldDivide: false))
                }
            case let .failure(error):
                self.handleError(error: error)
            }
            self.isLoading.accept(false)
        }
    }
    
    private func handleError(error: Error) {
        guard let error = error as? NetworkError else { return }
        switch error {
        case .invalidResponse:
            self.error.accept("Invalid Response")
        case .noData:
            self.error.accept("No Data")
        case .httpError(_, let response):
            if let response = response as? ErrorModel {
                self.error.accept(response.message)
            }
        }
    }
}
