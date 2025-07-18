//
//  CPUManager.swift
//  RunCat365MacOS
//
//  Created by Yash Prajapati on 18/07/25.
//
import Foundation

class SystemCPU {
    
    private var previousCPUInfo: [Int32] = []
    private var previousTimestamp: CFTimeInterval = 0
    
    func getCPUUtilization() -> Double {
        var cpuInfo: UnsafeMutablePointer<integer_t>? = nil
        var numCpuInfo: mach_msg_type_number_t = 0
        var numCpus: natural_t = 0
        
        let result = host_processor_info(mach_host_self(),
                                       PROCESSOR_CPU_LOAD_INFO,
                                       &numCpus,
                                       &cpuInfo,
                                       &numCpuInfo)
        
        guard result == KERN_SUCCESS, let cpuInfo = cpuInfo else {
            return 0.0
        }
        
        defer {
            vm_deallocate(mach_task_self_,
                         vm_address_t(bitPattern: cpuInfo),
                         vm_size_t(numCpuInfo))
        }
        
        let currentTimestamp = CFAbsoluteTimeGetCurrent()
        var currentCPUInfo: [Int32] = []
        
        for i in 0..<Int(numCpus) {
            let cpuLoadInfo = cpuInfo.advanced(by: Int(CPU_STATE_MAX) * i)
            for j in 0..<Int(CPU_STATE_MAX) {
                currentCPUInfo.append(cpuLoadInfo[j])
            }
        }
        
        if !previousCPUInfo.isEmpty && previousCPUInfo.count == currentCPUInfo.count {
            let usage = calculateCPUUsage(current: currentCPUInfo,
                                        previous: previousCPUInfo,
                                        cpuCount: Int(numCpus))
            
            previousCPUInfo = currentCPUInfo
            previousTimestamp = currentTimestamp
            
            return usage
        } else {
            previousCPUInfo = currentCPUInfo
            previousTimestamp = currentTimestamp
            return 0.0
        }
    }
    
    private func calculateCPUUsage(current: [Int32], previous: [Int32], cpuCount: Int) -> Double {
        var totalUser: Int64 = 0
        var totalSystem: Int64 = 0
        var totalIdle: Int64 = 0
        var totalNice: Int64 = 0
        
        for i in 0..<cpuCount {
            let baseIndex = i * Int(CPU_STATE_MAX)
            
            let userDelta = Int64(current[baseIndex + Int(CPU_STATE_USER)] - previous[baseIndex + Int(CPU_STATE_USER)])
            let systemDelta = Int64(current[baseIndex + Int(CPU_STATE_SYSTEM)] - previous[baseIndex + Int(CPU_STATE_SYSTEM)])
            let idleDelta = Int64(current[baseIndex + Int(CPU_STATE_IDLE)] - previous[baseIndex + Int(CPU_STATE_IDLE)])
            let niceDelta = Int64(current[baseIndex + Int(CPU_STATE_NICE)] - previous[baseIndex + Int(CPU_STATE_NICE)])
            
            totalUser += userDelta
            totalSystem += systemDelta
            totalIdle += idleDelta
            totalNice += niceDelta
        }
        
        let totalTicks = totalUser + totalSystem + totalIdle + totalNice
        
        if totalTicks > 0 {
            let activeTicks = totalUser + totalSystem + totalNice
            return (Double(activeTicks) / Double(totalTicks)) * 100.0
        }
        
        return 0.0
    }
    
    func reset() {
        previousCPUInfo.removeAll()
        previousTimestamp = 0
    }
}
