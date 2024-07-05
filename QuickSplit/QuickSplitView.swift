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
                        PersonView(person: person, splitType: viewModel.splitType, onChange: viewModel.computeAmountsPerPerson)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("QuickSplit")
        }
    }
    
    
    // MARK: - Inputs
    
    @State private var refreshAmountInput = false
    var amountInput: some View {
        HStack {
            Text("Amount")
                .font(.title)
            TextField("Amount",
                      value: $viewModel.amount.onChange(perform: viewModel.computeAmountsPerPerson),
                      format: .currency(code: currencyCode),
                      prompt: Text("0 \(currencySymbol)"))
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
            TextField("Tip",
                      value: $viewModel.tipPercentage.onChange(perform: viewModel.computeAmountsPerPerson),
                      format: .percent,
                      prompt: Text("0%"))
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
                    onIncrement: {
                        viewModel.addPerson()
                        viewModel.computeAmountsPerPerson()
                    },
                    onDecrement: {
                        viewModel.removePerson()
                        viewModel.computeAmountsPerPerson()
                    })
                .font(.title)
                .fixedSize()
        }
    }
    
    var splitTypeInput: some View {
        Picker("Split type", selection: $viewModel.splitType.onChange(perform: viewModel.computeAmountsPerPerson)) {
            ForEach(SplitType.allCases) { splitType in
                Text(splitType.rawValue.capitalized)
            }
        }
        .pickerStyle(.segmented)
    }
}




// MARK: - Preview

#Preview {
    QuickSplitView(viewModel: QuickSplitViewModel())
}
