//
//  Time.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation

struct Time {
    private(set) var last: TimeInterval? = nil
    private(set) var delta: TimeInterval = 0
    
    mutating func update(current: TimeInterval) {
        if let last = last {
            delta = current - last
        }
        last = current
    }
}
