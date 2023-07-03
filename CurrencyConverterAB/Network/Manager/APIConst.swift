//
//  APIConst.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation

public enum APIBase:String {
    case debug = "some debug url"
    case production = "http://api.exchangeratesapi.io/v1/"
}

public struct APIConfig {
    public static let base: APIBase = .production
}

