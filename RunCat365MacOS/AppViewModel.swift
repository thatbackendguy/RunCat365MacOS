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
    
    private let systemCPU = SystemCPU()
    private var animationTimer: Timer?

    init() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let currentUsage = self.systemCPU.getCPUUtilization()
            
            DispatchQueue.main.async {
                self.cpuUsage = currentUsage
            }
            
            self.updateAnimationSpeed()
        }
    }

    var iconName: String {
        return "cat_\(currentFrame)"
    }

    private func updateAnimationSpeed() {
        let interval = max(0.05, 0.5 - (cpuUsage / 200.0))
        
        animationTimer?.invalidate()
        
        let timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.animate()
        }
        animationTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func animate() {
        currentFrame = (currentFrame + 1) % 5
    }
}
