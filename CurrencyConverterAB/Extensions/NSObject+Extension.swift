//
//  NSObject+Extension.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation
public extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
