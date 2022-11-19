//
//  SKPhysicsContact+Ext.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

extension SKPhysicsContact {
    func isBetween(_ bitmaskA: UInt32, _ bitmaskB: UInt32) -> Bool {
        bodyA.categoryBitMask == bitmaskA && bodyB.categoryBitMask == bitmaskB
        ||
        bodyA.categoryBitMask == bitmaskB && bodyB.categoryBitMask == bitmaskA
    }
    
    func firstBody(with categoryBitMask: UInt32) -> SKPhysicsBody? {
        [bodyA, bodyB].first(where: { $0.categoryBitMask == categoryBitMask })
    }
}
