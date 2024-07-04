//
//  QuickSplit.swift
//  QuickSplit
//
//  Created by Natxo Raga on 1/7/24.
//

import SwiftUI


struct QuickSplitView: View {
    let currencyCode = Locale.current.currency?.identifier ?? "EUR"
    let currencySymbol = Locale.current.currencySymbol ?? "€"
    
    @Bindable var viewModel: QuickSplitViewModel
    
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
    
    var amountInput: some View {
        HStack {
            Text("Amount")
                .font(.title)
            TextField("Amount", value: $viewModel.amount, format: .currency(code: currencyCode), prompt: Text("0 \(currencySymbol)"))
                .font(.largeTitle)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
        }
    }
    
    var tipPercentageInput: some View {
        HStack {
            Text("Tip")
                .font(.title)
            TextField("Tip", value: $viewModel.tipPercentage, format: .percent, prompt: Text("0%"))
                .font(.largeTitle)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
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


struct PersonView: View {
    let currencyCode = Locale.current.currency?.identifier ?? "EUR"
    let currencySymbol = Locale.current.currencySymbol ?? "€"
    
    @Bindable var person: Person
    let splitType: SplitType
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "person.fill")
                    .font(.largeTitle)
                
                VStack {
                    HStack {
                        Spacer()
                        switch splitType {
                            case .parts: partsInput
                            case .percentages: percentageInput
                        }
                        Spacer()
                        offsetInput
                    }
                    .font(.title2)
                    
                    amountToPayView
                }
            }
            Divider()
        }
    }
    
    var partsInput: some View {
        Stepper("\(person.parts) part(s)", value: $person.parts, in: 0...100)
            .fixedSize()
    }
    
    var percentageInput: some View {
        TextField("Percentage", value: $person.percentage, format: .percent, prompt: Text("0%"))
            .fixedSize()
            .keyboardType(.numberPad)
    }
    
    var offsetInput: some View {
        Group {
            Text("+")
            TextField("Offset", value: $person.offset, format: .currency(code: currencyCode), prompt: Text("0 \(currencySymbol)"))
                .fixedSize()
                .keyboardType(.numberPad)
        }
    }
    
    var amountToPayView: some View {
        HStack {
            Spacer()
            Text("To pay: \(person.amountToPay.formatted(.currency(code: currencyCode)))")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.red)
        }
    }
}




#Preview {
    QuickSplitView(viewModel: QuickSplitViewModel())
}
