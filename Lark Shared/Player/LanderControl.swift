//
//  LanderControl.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import CoreGraphics

class LanderControl {
    var lander: Lander?
    var enabled: Bool = true {
        didSet {
            if !enabled {
                leftThruster?.release()
                rightThruster?.release()
            }
        }
    }
    
    var leftThruster: Truster? { lander?.leftTruster }
    var rightThruster: Truster? { lander?.rightTruster }
    
    init() {}
    
    func update() {
        if enabled {
            lander?.leftTruster.apply(on: lander)
            lander?.rightTruster.apply(on: lander)
        }
    }
}
