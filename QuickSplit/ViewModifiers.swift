//
//  ViewModifiers.swift
//  QuickSplit
//
//  Created by Natxo Raga on 4/7/24.
//

import SwiftUI


// MARK: - KeyboardToolbarButton

struct KeyboardToolbarButton<V: View>: ViewModifier {
    let condition: Bool
    let button: () -> V
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if condition {
                        Spacer()
                        button()
                    }
                }
            }
    }
}

extension View {
    func keyboardToolbarButton<V: View>(condition: Bool, @ViewBuilder button: @escaping () -> V) -> some View {
        modifier(KeyboardToolbarButton(condition: condition, button: button))
    }
}


// MARK: - RefreshOnLostFocus

// Hack to refresh the view when it loses focus (forcing format to be applied)
// Should be done automatically by Swift (bug?)
struct RefreshOnLostFocus: ViewModifier {
    var isFocused: Bool
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
    func refreshOnLostFocus(isFocused: Bool, refreshToggle: Binding<Bool>) -> some View {
        modifier(RefreshOnLostFocus(isFocused: isFocused, refreshToggle: refreshToggle))
    }
}
