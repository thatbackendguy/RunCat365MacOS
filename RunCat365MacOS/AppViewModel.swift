//
//  AppViewModel.swift
//  RunCat365MacOS
//
//  Created by Yash Prajapati on 18/07/25.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var currentFrame = 0
    @Published var cpuUsage: Double = 0.0
    
    @Published var selectedRunner: String = "cat" {
        didSet {
            currentFrame = 0
        }
    }

    private let frameCounts = [
        "cat": 5,
        // You can add more runners here once you have the assets.
        // "parrot": 10,
        // "horse": 14
    ]
    
    private var animationTimer: Timer?

    init() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.cpuUsage = getCPUUsage()
            self?.updateAnimationSpeed()
        }
    }

    var iconName: String {
        return "\(selectedRunner)_\(currentFrame)"
    }

    private func updateAnimationSpeed() {
        let interval = max(0.05, 0.5 - (cpuUsage / 200.0))
        
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.animate()
        }
    }

    private func animate() {
        guard let frameCount = frameCounts[selectedRunner] else { return }
        currentFrame = (currentFrame + 1) % frameCount
    }
}
