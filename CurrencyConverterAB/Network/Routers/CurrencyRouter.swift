//
//  CurrencyRouter.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation

enum CurrencyRouter: RouterProtocol {
    case symbols
    case latestCurrency(base: String, symbols: String)
}
extension CurrencyRouter {
    
    var url: URL {
        switch self {
        case .symbols:
            return URL(string: baseURL + path + "?access_key=e3edecfa2e36bb68ca89c09f38194ae7")!
        case let .latestCurrency(_, symbols):
            return URL(string: baseURL + path + "?access_key=e3edecfa2e36bb68ca89c09f38194ae7&symbols=\(symbols)")!
        }
        
    }
    
    var baseURL: String {
        return APIBase.production.rawValue
    }
    
    var path: String {
        switch self {
        case .symbols:
            return "symbols"
        case .latestCurrency:
            return "latest"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .symbols, .latestCurrency:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .symbols, .latestCurrency:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
