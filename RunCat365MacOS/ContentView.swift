//
//  ContentView.swift
//  RunCat365MacOS
//
//  Created by Yash Prajapati on 18/07/25.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    
    @AppStorage("shouldLaunchAtLogin") private var shouldLaunchAtLogin: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CPU: \(String(format: "%.1f", viewModel.cpuUsage))%")
                .font(.headline)
            
            Divider()
            
            Toggle(isOn: $shouldLaunchAtLogin) {
                Text("Launch at Login")
            }
            .onChange(of: shouldLaunchAtLogin) {
                LaunchAtLoginManager.shared.toggleLaunchAtLogin(isOn: shouldLaunchAtLogin)
            }

            Divider()

            Button("Quit RunCat") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 220)
    }
}
