//
//  LanderBombContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-30.
//

import Foundation
import SpriteKit

struct LanderBombContactHandler: ContactHandler {
    let successor: ContactHandler?

    func handle(contact: SKPhysicsContact) {
        guard contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.bomb
        ) else { return }

        guard
            let lander = contact
                .firstBody(with: Const.PhysicsBody.Bitmask.lander)?
                .parentNode(ofType: Lander.self),
            let bomb = contact
                .firstBody(with: Const.PhysicsBody.Bitmask.bomb)?
                .parentNode(ofType: Bomb.self)
        else { return }

        if !lander.isHooked {
            lander.attachHook(to: bomb)
            bomb.engage()

            // Automatically replace the bomb when picked up
            let newBomb = Bomb()
            newBomb.position = bomb.position
            bomb.parent?.addChild(newBomb)
        }
    }
}
