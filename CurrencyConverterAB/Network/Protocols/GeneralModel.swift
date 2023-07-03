//
//  GeneralModel.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation

protocol GeneralResponse: Decodable {
    var success: Bool? { get }
    var error: ErrorModel? { get }
}

struct ErrorModel: Decodable {
    var code: String?
    var message: String?
}
