//
//  QuickSplitModel.swift
//  QuickSplit
//
//  Created by Natxo Raga on 3/7/24.
//

import Foundation


struct QuickSplitModel {
    var amount: Double?
    var tipPercentage: Int?
    var splitType: SplitType = .parts
    var people = [Person(id: 0), Person(id: 1)]
    
    mutating func addPerson() {
        people.append(Person(id: people.count))
    }
    
    mutating func removePerson() {
        if people.count > 1 { people.removeLast() }
    }
    
    mutating func computeAmountsPerPerson() {
        let amount = amount ?? 0.0
        let tipPercentage = tipPercentage ?? 0
        let totalAmount = amount + (amount * Double(tipPercentage)/100.0)
        var remainingAmount = totalAmount
        
        var totalParts = 0
        for index in people.indices {
            // Init
            totalParts += people[index].parts
            people[index].amountToPay = 0.0
            
            // Offset first
            people[index].amountToPay += people[index].offset
            remainingAmount -= people[index].offset
        }
        
        // Amount to pay (by parts)
        let partAmount = remainingAmount/Double(totalParts)
        for index in people.indices {
            people[index].amountToPay += partAmount
            remainingAmount -= partAmount
        }
        /*if remainingAmount > 0.0 {
            people[0].amountToPay += remainingAmount
        }*/
    }
}


struct Person: Identifiable {
    let id: Int
    var parts = 1
    var percentage = 0
    var offset = 0.0
    var amountToPay = 0.0
}


enum SplitType: String, CaseIterable, Identifiable {
    case parts, percentages
    var id: Self { self }
}
