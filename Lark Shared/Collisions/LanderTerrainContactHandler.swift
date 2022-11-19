//
//  LanderTerrainContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

struct LanderTerrainContactHandler: ContactHandler {
    let scene: GameScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        guard contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.terrain
        ) else { return }

        guard let lander = scene.lander else { return }
        let collisionSpeed = lander.lastSpeed  // this doesn't seem to measure velocity properly
        
        // TODO: Dot prod of velocity to contact point to find speed component?

        if collisionSpeed > Const.Node.Lander.collisionSpeedDeathThreshold {
            let dropPosition = scene.convert(.zero, from: lander)
            scene.destroyLander()
            let droppedGems = scene.cargo.unloadGems()
            for droppedGem in droppedGems {
                droppedGem.drop(in: scene, at: dropPosition)
            }
        }
    }
}
