//
//  FX.Bounce.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-16.
//

import Foundation
import SpriteKit

extension FX {
    static func bounce() -> SKAction {
        let scaleMult: CGFloat = 1.25
        let action = SKAction.sequence([
            .scale(by: scaleMult, duration: 0.1),
            .scale(by: 1.0 / scaleMult, duration: 0.1)
        ])
        action.timingMode = .easeInEaseOut
        return action
    }
}
