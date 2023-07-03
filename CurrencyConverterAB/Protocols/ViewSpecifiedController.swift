//
//  ViewSpecifiedController.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation
import UIKit

protocol ViewSpecificController {
    associatedtype RootView: UIView
}

extension ViewSpecificController where Self: UIViewController {
    func view() -> RootView {
        return self.view as! RootView
    }
}
