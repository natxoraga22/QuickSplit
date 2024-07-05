//
//  Binding+OnChange.swift
//  QuickSplit
//
//  Created by Natxo Raga on 5/7/24.
//

import SwiftUI


extension Binding {
    // onChange method used to perform an action every time the binding value changes
    // Used to prevent multiple View.onChange(of:) calls in QuickSplitView
    public func onChange(perform action: @escaping () -> Void) -> Self where Value: Equatable {
        .init(
            get: { self.wrappedValue },
            set: { newValue in
                guard self.wrappedValue != newValue else { return }
                self.wrappedValue = newValue
                action()
            }
        )
    }
}
