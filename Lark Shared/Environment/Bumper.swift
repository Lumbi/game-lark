//
//  Bumper.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-06.
//

import Foundation
import SpriteKit

class Bumper: SKNode {
    override init() {
        super.init()

        let sprite = SKSpriteNode(imageNamed: "spr_jello")
        sprite.size = .init(width: 32, height: 32)
        addChild(sprite)

        let body = SKPhysicsBody(circleOfRadius: 14)
        body.affectedByGravity = false
        body.isDynamic = false
        body.categoryBitMask = Const.PhysicsBody.Bitmask.bumper
        body.collisionBitMask = Const.PhysicsBody.Bitmask.lander
        physicsBody = body
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func wobble() {
        removeAllActions()
        run(FX.shake(duration: 0.3))
    }
}
