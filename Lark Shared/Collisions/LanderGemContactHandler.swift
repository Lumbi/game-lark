//
//  LanderGemContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

struct LanderGemContactHandler: ContactHandler {
    let scene: LevelScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        guard
            contact.isBetween(
                Const.PhysicsBody.Bitmask.lander,
                Const.PhysicsBody.Bitmask.collectible
            )
        else { return }
        
        let gem = contact
            .firstBody(with: Const.PhysicsBody.Bitmask.collectible)?
            .parentNode(ofType: Gem.self)

        if let gem = gem {
            scene.cargo.pickUp(gem: gem)
        }
    }
}
