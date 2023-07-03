//
//  String+Extensions.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation

extension String {
    func formatCurrency(shouldDivide: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        var amountWithPrefix = self
        var number: NSNumber!

        if shouldDivide {
            let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
            amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
            
            let double = (amountWithPrefix as NSString).doubleValue
            number = NSNumber(value: (double / 100))
            
            guard number != 0 as NSNumber else {
                return ""
            }
        } else {
            let double = (amountWithPrefix as NSString).doubleValue
            number = NSNumber(value: double)
            
            guard number != 0 as NSNumber else {
                return ""
            }
        }
        
        return formatter.string(from: number)!
    }
    
}
