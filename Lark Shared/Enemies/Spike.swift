//
//  Spike.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-06.
//

import Foundation
import SpriteKit

class Spike: SKNode {
    override init() {
        super.init()

        let sprite = SKSpriteNode(imageNamed: "spr_spike")
        sprite.size = .init(width: 32, height: 32)
        addChild(sprite)

        let body = SKPhysicsBody(circleOfRadius: 14)
        body.isDynamic = false
        body.affectedByGravity = false
        body.categoryBitMask = Const.PhysicsBody.Bitmask.enemy
        body.collisionBitMask = Const.PhysicsBody.Bitmask.lander
        physicsBody = body
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
