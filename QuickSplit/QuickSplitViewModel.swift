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
    
    
    // MARK: - Main function
    
    func computeAmountsPerPerson() {
        // totalAmount = amount + tip
        let totalAmount = (amount ?? 0.0) + ((amount ?? 0.0) * Double(tipPercentage ?? 0)/100.0)
        var remainingAmount = totalAmount
        
        // First, add offsets to person.amountToPay
        people = people.map { person in
            person.amountToPay = person.offset ?? 0.0
            remainingAmount -= person.offset ?? 0.0
            return person
        }
        
        // Compute amounts based on splitType
        switch splitType {
            case .parts: remainingAmount = computeAmountsPerPersonByParts(remainingAmount: remainingAmount)
            case .percentages: remainingAmount = computeAmountsPerPersonByPercentage(remainingAmount: remainingAmount)
        }
        
        // Remaining amount assigned to first person (change it to random?)
        if remainingAmount > 0.0 { people[0].amountToPay += remainingAmount }
    }
    
    private func computeAmountsPerPersonByParts(remainingAmount: Double) -> Double {
        var remainingAmount = remainingAmount
        // Count total parts
        let totalParts = people.reduce(0) { result, person in result + person.parts }
        
        // Amount to pay (by parts)
        let partAmount = remainingAmount/Double(totalParts)
        people = people.map { person in
            let amountToPayByParts = partAmount * Double(person.parts)
            person.amountToPay += amountToPayByParts
            remainingAmount -= amountToPayByParts
            return person
        }
        return remainingAmount
    }
    
    private func computeAmountsPerPersonByPercentage(remainingAmount: Double) -> Double {
        var remainingAmount = remainingAmount
        // Set equal percentages if all are empty
        let percentagesAreEmpty = people.allSatisfy { person in person.percentage == nil }
        if percentagesAreEmpty {
            let equalPercentage = 100/people.count
            people = people.map { person in
                person.percentage = equalPercentage
                return person
            }
            people[0].percentage! += 100%people.count
        }

        // Amount to pay (by percentage)
        let totalAmount = remainingAmount
        people = people.map { person in
            let amountToPayByPercentage = totalAmount * Double(person.percentage ?? 0)/100.0
            person.amountToPay += amountToPayByPercentage
            remainingAmount -= amountToPayByPercentage
            return person
        }
        return remainingAmount
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
