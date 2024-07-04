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
    
    var remainingPercentage: Int {
        var remainingPercentage = 100
        for person in people { remainingPercentage -= person.percentage ?? 0 }
        return remainingPercentage
    }
    
    func addPerson() {
        people.append(Person())
    }
    
    func removePerson() {
        if people.count > 1 { people.removeLast() }
    }
    
    func computeAmountsPerPerson() {
        var remainingAmount = (amount ?? 0.0) + ((amount ?? 0.0) * Double(tipPercentage ?? 0)/100.0)
        
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
        if splitType == .parts {
            let partAmount = remainingAmount/Double(totalParts)
            for index in people.indices {
                let amountToPayByParts = partAmount * Double(people[index].parts)
                people[index].amountToPay += amountToPayByParts
                remainingAmount -= amountToPayByParts
            }
        }
        
        // Amount to pay (by percentage)
        else if splitType == .percentages {
            let totalAmount = remainingAmount
            for index in people.indices {
                let amountToPayByPercentage = totalAmount * Double(people[index].percentage ?? 0)/100.0
                people[index].amountToPay += amountToPayByPercentage
                remainingAmount -= amountToPayByPercentage
            }
        }
        
        // Remaining amount assigned to first person (change it to random?)
        if remainingAmount > 0.0 {
            people[0].amountToPay += remainingAmount
        }
    }
}


@Observable
class Person: Identifiable, Equatable {
    let id = UUID()
    
    var parts = 1
    var percentage: Int?
    var offset: Double?
    var amountToPay = 0.0
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}


enum SplitType: String, CaseIterable, Identifiable {
    case parts, percentages
    var id: Self { self }
}
