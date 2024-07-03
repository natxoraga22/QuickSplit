//
//  QuickSplitViewModel.swift
//  QuickSplit
//
//  Created by Natxo Raga on 3/7/24.
//

import Foundation


@Observable
class QuickSplitViewModel {
    private var model = QuickSplitModel()
    
    var amount: Double? {
        get { model.amount }
        set(newAmount) { model.amount = newAmount }
    }
    
    var tipPercentage: Int? {
        get { model.tipPercentage }
        set(newTipPercentage) { model.tipPercentage = newTipPercentage }
    }
    
    var splitType: SplitType {
        get { model.splitType }
        set(newSplitType) { model.splitType = newSplitType }
    }
    
    var people: [Person] {
        get { model.people }
        set(newPeople) { model.people = newPeople }
    }
    
    func addPerson() {
        model.addPerson()
    }
    
    func removePerson() {
        model.removePerson()
    }
}
