//
//  QuickSplitApp.swift
//  QuickSplit
//
//  Created by Natxo Raga on 1/7/24.
//

import SwiftUI


@main
struct QuickSplitApp: App {
    @State private var quickSplitViewModel = QuickSplitViewModel()
    
    var body: some Scene {
        WindowGroup {
            QuickSplitView(viewModel: quickSplitViewModel)
        }
    }
}
