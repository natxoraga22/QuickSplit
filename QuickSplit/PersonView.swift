//
//  PersonView.swift
//  QuickSplit
//
//  Created by Natxo Raga on 4/7/24.
//

import SwiftUI


struct PersonView: View {
    let currencyCode = Locale.current.currency?.identifier ?? "EUR"
    let currencySymbol = Locale.current.currencySymbol ?? "€"
    
    enum Field: Hashable {
        case percentage, offset
    }
        
    @Bindable var person: Person
    let splitType: SplitType
    let onChange: () -> Void
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                personIcon
                
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
                    amountToPayView
                }
            }
            Divider()
        }
    }
    
    
    // MARK: - Subviews
    
    private var personIcon: some View {
        Image(systemName: "person.crop.circle.fill")
            .imageScale(.large)
            .font(.largeTitle)
            .opacity(0.3)
    }
    
    private var amountToPayView: some View {
        HStack {
            Spacer()
            Text("To pay: \(person.amountToPay.formatted(.currency(code: currencyCode)))")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.red)
        }
    }
    
    
    // MARK: - Inputs
    
    private var partsInput: some View {
        Stepper("\(person.parts) part(s)", value: $person.parts.onChange(perform: onChange), in: 0...100)
            .font(.title2)
            .fixedSize()
    }
    
    @State private var refreshPercentageInput = false
    private var percentageInput: some View {
        TextField("Percentage",
                  value: $person.percentage.onChange(perform: onChange),
                  format: .percent,
                  prompt: Text("0%"))
            .font(.title2)
            .fixedSize()
            .keyboardType(.numberPad)
            .keyboardToolbarButton(condition: focusedField == .percentage) {
                Button("Done") {
                    focusedField = nil
                }
            }
            .refreshOnLostFocus(isFocused: focusedField == .percentage, refreshToggle: $refreshPercentageInput)
    }
    
    @State private var refreshOffsetInput = false
    private var offsetInput: some View {
        TextField("Offset",
                  value: $person.offset.onChange(perform: onChange),
                  format: .currency(code: currencyCode).sign(strategy: .always()),
                  prompt: Text("+0 \(currencySymbol)"))
            .font(.title2)
            .fixedSize()
            .focused($focusedField, equals: .offset)
            .keyboardType(.numberPad)
            .keyboardToolbarButton(condition: focusedField == .offset) {
                Button("Done") {
                    focusedField = nil
                }
            }
            .refreshOnLostFocus(isFocused: focusedField == .offset, refreshToggle: $refreshOffsetInput)
    }
    
}
