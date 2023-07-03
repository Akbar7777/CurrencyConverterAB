//
//  SymbolsModel.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation

struct Symbols: GeneralResponse {
    var success: Bool?
    
    var error: ErrorModel?
    
    var symbols: [String : String?]?
}
