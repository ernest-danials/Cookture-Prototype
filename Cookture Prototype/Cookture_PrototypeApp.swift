//
//  Cookture_PrototypeApp.swift
//  Cookture Prototype
//
//  Created by Myung Joon Kang on 2025-04-03.
//

import SwiftUI
import ErrorManager

@main
struct Cookture_PrototypeApp: App {
    @StateObject var viewModel = ViewModel()
    @StateObject var errorManager = ErrorManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(errorManager)
        }
    }
}
