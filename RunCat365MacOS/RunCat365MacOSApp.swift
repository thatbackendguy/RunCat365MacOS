//
//  RunCat365MacOSApp.swift
//  RunCat365MacOS
//
//  Created by Yash Prajapati on 18/07/25.
//

import SwiftUI

@main
struct RunCatMacOSApp: App {
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Image("cat_0")
        }
    }
}
