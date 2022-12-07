//
//  BombTerrainContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-30.
//

import Foundation
import SpriteKit
import SKTiled

struct BombTerrainContactHandler: ContactHandler {
    let level: LevelScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        guard contact.isBetween(
            Const.PhysicsBody.Bitmask.bomb,
            Const.PhysicsBody.Bitmask.terrain
        ) else { return }
        
        guard
            let bomb = contact
                .firstBody(with: Const.PhysicsBody.Bitmask.bomb)?
                .parentNode(ofType: Bomb.self),
            let tile = contact
                .firstBody(with: Const.PhysicsBody.Bitmask.terrain)?
                .parentNode(ofType: SKTile.self),
            tile.isDestructible
        else { return }
        
        tile.destroy()
        bomb.explode()
    }
}
