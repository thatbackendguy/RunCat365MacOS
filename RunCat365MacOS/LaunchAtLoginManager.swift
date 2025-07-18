//
//  LaunchAtLoginManager.swift
//  RunCat365MacOS
//
//  Created by Yash Prajapati on 18/07/25.
//

import ServiceManagement
import SwiftUI

class LaunchAtLoginManager {
    static let shared = LaunchAtLoginManager()

    func toggleLaunchAtLogin(isOn: Bool) {
        do {
            if isOn {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("❌ Failed to update Launch at Login setting: \(error.localizedDescription)")
        }
    }
}
