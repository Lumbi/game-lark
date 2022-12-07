//
//  LanderBumperContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-06.
//

import Foundation
import SpriteKit

struct LanderBumpberContactHandler: ContactHandler {
    let level: LevelScene
    let successor: ContactHandler?

    func handle(contact: SKPhysicsContact) {
        guard contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.bumper
        ) else { return }

        level.lander.physicsBody?.velocity = .zero
        level.lander.physicsBody?.applyImpulse(Const.Node.Bumper.force * contact.contactNormal)

        let bumper = contact
            .firstBody(with: Const.PhysicsBody.Bitmask.bumper)?
            .parentNode(ofType: Bumper.self)
        bumper?.wobble()
    }
}
