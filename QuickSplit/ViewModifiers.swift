//
//  ViewModifiers.swift
//  QuickSplit
//
//  Created by Natxo Raga on 4/7/24.
//

import SwiftUI


struct KeyboardDoneButton<ButtonView>: ViewModifier where ButtonView: View {
    let condition: Bool
    let button: () -> ButtonView
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if (condition) {
                        Spacer()
                        button()
                    }
                }
            }
    }
}

extension View {
    func keyboardDoneButton(condition: Bool, button: @escaping () -> some View) -> some View {
        modifier(KeyboardDoneButton(condition: condition, button: button))
    }
}

/*
struct RefreshOnLostFocus: ViewModifier {
    @Binding var isFocused: Bool
    @Binding var refreshToggle: Bool
    
    func body(content: Content) -> some View {
        content
            .id(refreshToggle)
            .onChange(of: isFocused) { oldValue, newValue in
                if oldValue && !newValue {
                    refreshToggle.toggle()
                }
            }
    }
}

extension View {
    func refreshOnLostFocus(isFocused: Binding<Bool>, refreshToggle: Binding<Bool>) -> some View {
        modifier(RefreshOnLostFocus(isFocused: isFocused, refreshToggle: refreshToggle))
    }
}
*/
