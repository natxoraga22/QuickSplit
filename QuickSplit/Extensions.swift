//
//  Extensions.swift
//  QuickSplit
//
//  Created by Natxo Raga on 2/7/24.
//

import Foundation


extension Formatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.zeroSymbol = ""
        return formatter
    }()
}
