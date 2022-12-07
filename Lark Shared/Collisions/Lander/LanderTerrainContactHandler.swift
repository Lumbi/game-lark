//
//  LanderTerrainContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

struct LanderTerrainContactHandler: ContactHandler {
    let level: LevelScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        guard contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.terrain
        ) else { return }

        let collisionSpeed = level.lander.lastSpeed
        
        // TODO: Dot prod of velocity to contact point to find speed component?

        if collisionSpeed > Const.Node.Lander.collisionSpeedDeathThreshold {
            level.destroyLander()
        }
    }
}
