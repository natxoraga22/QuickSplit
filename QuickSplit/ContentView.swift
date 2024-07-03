//
//  ContentView.swift
//  QuickSplit
//
//  Created by Natxo Raga on 1/7/24.
//

import SwiftUI


struct ContentView: View {
    @State private var amount = 0.0
    @State private var tipPercentage = 0
    @State private var people: [Person] = [Person(id: 0), Person(id: 1)]
    @State private var splitType: SplitType = .parts
    
    private var total: Double {
        return amount * (1.0 + Double(tipPercentage)/100.0)
    }
        
    func addPerson() {
        people.append(Person(id: people.count))
    }
    
    func removePerson() {
        if people.count > 1 { people.removeLast() }
    }
    
    func computeAmountsPerPerson() {
        
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // AMOUNT
                    HStack {
                        Text("Amount")
                            .font(.title)
                        TextField("Amount", value: $amount, formatter: Formatter.currencyFormatter, prompt: Text("0"))
                            .font(.largeTitle)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                        Text(Locale.current.currencySymbol ?? "€")
                            .font(.largeTitle)
                    }
                    
                    // TIP
                    HStack {
                        Text("Tip")
                            .font(.title)
                        TextField("Tip", value: $tipPercentage, formatter: Formatter.percentFormatter, prompt: Text("0"))
                            .font(.largeTitle)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .onChange(of: tipPercentage) { oldValue, newValue in
                                if newValue > 100 { tipPercentage = oldValue }
                            }
                        Text("%")
                            .font(.largeTitle)
                    }
                }
                .padding()
                
                // NUMBER OF PEOPLE
                HStack {
                    Text("People")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Spacer()
                    Stepper("\(people.count)", onIncrement: { addPerson() }, onDecrement: { removePerson() })
                        .font(.title)
                        .fixedSize()
                }
                .padding()
                .padding([.top])
                
                // SPLIT TYPE
                if !people.isEmpty {
                    Picker("Split type", selection: $splitType) {
                        ForEach(SplitType.allCases) { splitType in
                            Text(splitType.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding([.horizontal, .bottom])
                }
                
                // PEOPLE
                ForEach($people) { $person in
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "person.fill")
                            Spacer()
                            if splitType == .parts {
                                Stepper("\(person.parts) part(s)", value: $person.parts, in: 0...100)
                                    .fixedSize()
                            }
                            else if splitType == .percentages {
                                TextField("Percentage", value: $person.percentage, formatter: Formatter.percentFormatter, prompt: Text("0"))
                                    .fixedSize()
                                    .keyboardType(.numberPad)
                                Text("%")
                            }
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
                
                Spacer()
            }
            .navigationTitle("QuickSplit")
        }
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


#Preview {
    ContentView()
}
