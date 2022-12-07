//
//  FX.Shake.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-18.
//

import Foundation
import SpriteKit

extension FX {
    static func shake(duration: CGFloat, amplitudeX: Int = 8, amplitudeY: Int = 8) -> SKAction {
        let numberOfShakes = Int(duration / 0.015 / 2.0)
        let shakes = (1...Int(numberOfShakes))
            .map { _ -> [SKAction] in
                let dx = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
                let dy = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
                let forward = SKAction.moveBy(x: dx, y:dy, duration: 0.015)
                let reverse = forward.reversed()
                return [forward, reverse]
            }
            .flatMap { $0 }
        return .sequence(shakes)
    }
}
