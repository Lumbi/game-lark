//
//  TimeAccumulator.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-15.
//

import Foundation

struct TimeAccumulator {
    private let threshold: TimeInterval
    private var accumulated: TimeInterval = 0
    
    init(threshold: TimeInterval) {
        self.threshold = threshold
    }
    
    mutating func update(time: Time) -> Bool {
        accumulated += time.delta
        if accumulated > threshold {
            accumulated = 0
            return true
        } else {
            return false
        }
    }
}
