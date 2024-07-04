//
//  QuickSplit.swift
//  QuickSplit
//
//  Created by Natxo Raga on 1/7/24.
//

import SwiftUI


// TODO: Show remaining percentage when splitType == .percentage
// TODO: Default equal percentages


struct QuickSplitView: View {
    let currencyCode = Locale.current.currency?.identifier ?? "EUR"
    let currencySymbol = Locale.current.currencySymbol ?? "€"
    
    enum Field: Hashable {
        case amount, tipPercentage
    }
    
    @Bindable var viewModel: QuickSplitViewModel
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    amountInput
                    tipPercentageInput
                    
                    numberOfPeopleInput
                        .padding([.top])
                        .padding([.top])
                    
                    if !viewModel.people.isEmpty {
                        splitTypeInput
                            .padding([.bottom])
                    }
                    
                    ForEach(viewModel.people) { person in
                        @Bindable var person = person
                        PersonView(person: person, splitType: viewModel.splitType)
                            // Update amounts per person on any input change
                            .onChange(of: person.parts) { viewModel.computeAmountsPerPerson() }
                            .onChange(of: person.percentage) { viewModel.computeAmountsPerPerson() }
                            .onChange(of: person.offset) { viewModel.computeAmountsPerPerson() }
                    }
                    Spacer()
                }
                .padding()
                // Update amounts per person on any input change
                .onChange(of: viewModel.amount) { viewModel.computeAmountsPerPerson() }
                .onChange(of: viewModel.tipPercentage) { viewModel.computeAmountsPerPerson() }
                .onChange(of: viewModel.splitType) { viewModel.computeAmountsPerPerson() }
                .onChange(of: viewModel.people) { viewModel.computeAmountsPerPerson() }
            }
            .navigationTitle("QuickSplit")
        }
    }
    
    @State private var refreshAmountInput = false
    var amountInput: some View {
        HStack {
            Text("Amount")
                .font(.title)
            TextField("Amount", value: $viewModel.amount, format: .currency(code: currencyCode), prompt: Text("0 \(currencySymbol)"))
                .font(.largeTitle)
                .multilineTextAlignment(.trailing)
                .focused($focusedField, equals: .amount)
                .keyboardType(.decimalPad)
                .keyboardToolbarButton(condition: focusedField == .amount) {
                    Button("Next") {
                        focusedField = .tipPercentage
                    }
                }
                .refreshOnLostFocus(isFocused: focusedField == .amount, refreshToggle: $refreshAmountInput)
        }
    }
    
    @State private var refreshTipPercentageInput = false
    var tipPercentageInput: some View {
        HStack {
            Text("Tip")
                .font(.title)
            TextField("Tip", value: $viewModel.tipPercentage, format: .percent, prompt: Text("0%"))
                .font(.largeTitle)
                .multilineTextAlignment(.trailing)
                .focused($focusedField, equals: .tipPercentage)
                .keyboardType(.numberPad)
                .keyboardToolbarButton(condition: focusedField == .tipPercentage) {
                    Button("Done") {
                        focusedField = nil
                    }
                }
                .refreshOnLostFocus(isFocused: focusedField == .tipPercentage, refreshToggle: $refreshTipPercentageInput)
        }
    }
    
    var numberOfPeopleInput: some View {
        HStack {
            Text("People")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Spacer()
            Stepper("\(viewModel.people.count)",
                    onIncrement: { viewModel.addPerson() },
                    onDecrement: { viewModel.removePerson() })
                .font(.title)
                .fixedSize()
        }
    }
    
    var splitTypeInput: some View {
        Picker("Split type", selection: $viewModel.splitType) {
            ForEach(SplitType.allCases) { splitType in
                Text(splitType.rawValue.capitalized)
            }
        }
        .pickerStyle(.segmented)
    }
}




#Preview {
    QuickSplitView(viewModel: QuickSplitViewModel())
}
