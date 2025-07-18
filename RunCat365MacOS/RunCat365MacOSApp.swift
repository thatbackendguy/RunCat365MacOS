//
//  RunCat365MacOSApp.swift
//  RunCat365MacOS
//
//  Created by Yash Prajapati on 18/07/25.
//

import SwiftUI

@main
struct RunCatMacOSApp: App {
    
    @StateObject private var viewModel = AppViewModel()

    var body: some Scene {
        MenuBarExtra {
            ContentView(viewModel: viewModel)
        } label: {
            Image(viewModel.iconName)
        }
    }
}

