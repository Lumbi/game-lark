//
//  FX.Blink.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-30.
//

import Foundation
import SpriteKit

extension FX {
    static func blink(color: UIColor, times: Int, speed: TimeInterval) -> SKAction {
        SKAction.sequence(
            (0..<times).map { _ in
                SKAction.sequence([
                    .colorize(with: color, colorBlendFactor: 1.0, duration: speed / 2.0),
                    .colorize(with: .clear, colorBlendFactor: 0.0, duration: speed / 2.0),
                ])
            }
        )
    }
}
