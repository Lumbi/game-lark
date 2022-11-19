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
            leftThruster?.enabled = enabled
            rightThruster?.enabled = enabled

            if !enabled {
                leftThruster?.release()
                rightThruster?.release()
            }
        }
    }
    
    var leftThruster: Thruster? { lander?.leftTruster }
    var rightThruster: Thruster? { lander?.rightTruster }
    
    init() {}
    
    func update() {
        if enabled {
            lander?.leftTruster.apply(on: lander)
            lander?.rightTruster.apply(on: lander)
        }
    }
}
