//
//  LanderBeginLanderDepotContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

struct BeginLanderDepotContactHandler: ContactHandler {
    let cargo: Cargo
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        guard contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.trigger
        ) else { return }

        if let depot = contact
            .firstBody(with: Const.PhysicsBody.Bitmask.trigger)?
            .parentNode(ofType: Depot.self)
        {
            if cargo.gemCount > 0 {
                depot.startGemDeposit()
            }
        }
    }
}

struct EndLanderDepotContactHandler: ContactHandler {
    let scene: LevelScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        guard contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.trigger
        ) else { return }
        
        if let depot = contact
            .firstBody(with: Const.PhysicsBody.Bitmask.trigger)?
            .parentNode(ofType: Depot.self)
        {
            depot.cancelGemDeposit()
        }
    }
}
