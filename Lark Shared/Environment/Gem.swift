//
//  Gem.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit

/*
 Collectible gem found within the level
 */

class Gem: SKNode {
    override init() {
        super.init()
        
        name = Const.Node.Name.gem
        let sprite = SKSpriteNode(imageNamed: "spr_gem")
        sprite.size = .init(width: 32, height: 28)
        addChild(sprite)
        
        physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.halfWidth)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = false
        physicsBody?.collisionBitMask = 0
        physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.collectible
        
        zPosition = Const.Node.ZPosition.interactive
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drop(in scene: SKScene, at position: CGPoint) {
        self.position = position
        physicsBody?.isDynamic = true
        physicsBody?.linearDamping = 0.5
        physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.terrain
        physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.transientCollectible
        
        scene.addChild(self)
        
        physicsBody?.applyImpulse(
            .init(
                dx: CGFloat.random(in: (-1...1)) * 3.0,
                dy: CGFloat.random(in: (-1...1)) * 3.0
            )
        )
        
        run(.sequence([
            .wait(forDuration: 1),
            .run { self.physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.collectible }
        ]))
    }
}
