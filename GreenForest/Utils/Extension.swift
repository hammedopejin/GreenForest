//
//  Extension.swift
//  GreenForest
//
//  Created by Hammed opejin on 2/13/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import Foundation

extension Double {
    
    func convertToCurrency() -> String {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        return currencyFormatter.string(from: NSNumber(value: self))!
    }
}
