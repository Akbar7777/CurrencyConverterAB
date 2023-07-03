//
//  RatesModel.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation

struct RatesModel: GeneralResponse {
    var success: Bool?
    
    var error: ErrorModel?
    
    var rates: [String: Double?]?
}
