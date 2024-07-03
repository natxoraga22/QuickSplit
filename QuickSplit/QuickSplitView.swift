//
//  QuickSplit.swift
//  QuickSplit
//
//  Created by Natxo Raga on 1/7/24.
//

import SwiftUI


struct QuickSplitView: View {
    @Bindable private var viewModel = QuickSplitViewModel()
    
    let currencyCode = Locale.current.currency?.identifier ?? "EUR"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                amountInput
                tipPercentageInput
                
                numberOfPeopleInput
                    .padding([.top])
                    .padding([.top])
                
                if !viewModel.people.isEmpty {
                    splitTypeInput
                        .padding([.bottom])
                }
                
                ForEach($viewModel.people) { $person in
                    PersonView(person: $person)
                }
                Spacer()
            }
            .navigationTitle("QuickSplit")
            .padding()
        }
    }
    
    var amountInput: some View {
        HStack {
            Text("Amount")
                .font(.title)
            TextField("Amount", value: $viewModel.amount, format: .currency(code: currencyCode), prompt: Text("0"))
                .font(.largeTitle)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
        }
    }
    
    var tipPercentageInput: some View {
        HStack {
            Text("Tip")
                .font(.title)
            TextField("Tip", value: $viewModel.tipPercentage, format: .percent, prompt: Text("0"))
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
    @Binding var person: Person
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "person.fill")
                Spacer()
                /*if splitType == .parts {
                    Stepper("\(person.parts) part(s)", value: $person.parts, in: 0...100)
                        .fixedSize()
                }
                else if splitType == .percentages {
                    TextField("Percentage", value: $person.percentage, formatter: Formatter.percentFormatter, prompt: Text("0"))
                        .fixedSize()
                        .keyboardType(.numberPad)
                    Text("%")
                }*/
                Spacer()
                Text("+")
                TextField("Offset", value: $person.offset, formatter: Formatter.currencyFormatter, prompt: Text("0"))
                    .fixedSize()
                    .keyboardType(.numberPad)
                Text(Locale.current.currencySymbol ?? "€")
            }
            .font(.title2)
            .padding([.horizontal])
            
            HStack {
                Spacer()
                Text("Amount to pay: \(person.amountToPay.formatted(.currency(code: Locale.current.currency?.identifier ?? "EUR")))")
                    .font(.headline)
            }
            .padding([.horizontal])
            
            Divider()
        }
    }
}




#Preview {
    QuickSplitView()
}
