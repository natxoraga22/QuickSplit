//
//  QuickSplitViewModel.swift
//  QuickSplit
//
//  Created by Natxo Raga on 3/7/24.
//

import Foundation


@Observable
class QuickSplitViewModel {
    var amount: Double?
    var tipPercentage: Int?
    var splitType: SplitType = .parts
    var people = [Person(), Person()]
    
    func addPerson() {
        people.append(Person())
    }
    
    func removePerson() {
        if people.count > 1 { people.removeLast() }
    }
    
    func computeAmountsPerPerson() {
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
            people[index].amountToPay += people[index].offset ?? 0.0
            remainingAmount -= people[index].offset ?? 0.0
        }
        
        // Amount to pay (by parts)
        let partAmount = remainingAmount/Double(totalParts)
        for index in people.indices {
            people[index].amountToPay += partAmount
            remainingAmount -= partAmount
        }
        if remainingAmount > 0.0 {
            people[0].amountToPay += remainingAmount
        }
    }
}


@Observable
class Person: Identifiable {
    let id = UUID()
    
    var parts = 1
    var percentage: Int?
    var offset: Double?
    var amountToPay = 0.0
}


enum SplitType: String, CaseIterable, Identifiable {
    case parts, percentages
    var id: Self { self }
}
