//
//  ContentView.swift
//  RunCat365MacOS
//
//  Created by Yash Prajapati on 18/07/25.
//
import SwiftUI

struct ContentView: View {
    // This observes the viewModel for changes to update the CPU text.
    @ObservedObject var viewModel: AppViewModel
    
    // This automatically saves and loads the user's "Launch at Login" preference.
    @AppStorage("shouldLaunchAtLogin") private var shouldLaunchAtLogin: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // CPU usage text is included here.
            Text("CPU: \(String(format: "%.1f", viewModel.cpuUsage))%")
                .font(.headline)
            
            Divider()
            
            // Toggle to control the "Launch at Login" setting.
            Toggle(isOn: $shouldLaunchAtLogin) {
                Text("Launch at Login")
            }
            .onChange(of: shouldLaunchAtLogin) {
                LaunchAtLoginManager.shared.toggleLaunchAtLogin(isOn: shouldLaunchAtLogin)
            }

            Divider()

            // Button to quit the app.
            Button("Quit RunCat") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 220)
    }
}
