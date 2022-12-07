//
//  LanderEnemyContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-06.
//

import Foundation
import SpriteKit

struct LanderEnemyContactHandler: ContactHandler {
    let level: LevelScene
    let successor: ContactHandler?

    func handle(contact: SKPhysicsContact) {
        guard contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.enemy
        ) else { return }

        level.destroyLander()
    }
}
