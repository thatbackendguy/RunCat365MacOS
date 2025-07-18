//
//  CPUManager.swift
//  RunCat365MacOS
//
//  Created by Yash Prajapati on 18/07/25.
//

import Foundation

func getCPUUsage() -> Double {
    var totalUsage: Double = 0.0
    var kr: kern_return_t
    var task_info_count: mach_msg_type_number_t

    task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
    var tinfo = [integer_t](repeating: 0, count: Int(task_info_count))

    kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &task_info_count)
    if kr != KERN_SUCCESS { return -1 }

    var thread_list: thread_act_array_t?
    var thread_count: mach_msg_type_number_t = 0
    defer {
        if let thread_list = thread_list {
            vm_deallocate(mach_task_self_, vm_address_t(UnsafePointer(thread_list).pointee), vm_size_t(thread_count))
        }
    }

    kr = task_threads(mach_task_self_, &thread_list, &thread_count)
    if kr != KERN_SUCCESS { return -1 }

    if let thread_list = thread_list {
        for j in 0..<Int(thread_count) {
            var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
            var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
            kr = thread_info(thread_list[j], thread_flavor_t(THREAD_BASIC_INFO), &thinfo, &thread_info_count)
            if kr != KERN_SUCCESS { return -1 }

            // --- THIS IS THE CORRECTED LINE ---
            let thread_basic_info = thinfo.withUnsafeBytes {
                $0.load(as: thread_basic_info_data_t.self)
            }
            // ------------------------------------

            if thread_basic_info.flags & TH_FLAGS_IDLE == 0 {
                totalUsage = totalUsage + (Double(thread_basic_info.cpu_usage) / Double(TH_USAGE_SCALE)) * 100
            }
        }
    }
    return totalUsage
}
