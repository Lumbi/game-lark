//
//  PickUp.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-29.
//

import Foundation
import SpriteKit

class Bomb: SKNode {
    override init() {
        super.init()
        
        name = Const.Node.Name.bomb
        
        let size = CGSize(width: 32, height: 32)
        
        let sprite = SKShapeNode(rectOf: size)
        sprite.lineWidth = 2
        sprite.strokeColor = .red
        sprite.fillColor = .brown
        addChild(sprite)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.bomb
        physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.terrain
        physicsBody?.contactTestBitMask = Const.PhysicsBody.Bitmask.terrain
        physicsBody?.density = 0.01
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func explode() {
        physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.none
        if let scene = scene {
            let position = scene.convert(.zero, from: self)
            FX.Explosion.play(in: scene, at: position)
            removeFromParent()
            
            let shockwave = Shockwave()
            shockwave.position = position
            scene.addChild(shockwave)
            shockwave.expand()
        }
    }
}

class Shockwave: SKNode {
    override init() {
        super.init()
        
        physicsBody = SKPhysicsBody(circleOfRadius: 1)
        physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.shockwave
        physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.terrain
        physicsBody?.contactTestBitMask = Const.PhysicsBody.Bitmask.terrain
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        run(
            .sequence([
                .scale(to: 50, duration: 0.3),
                .removeFromParent()
            ])
        )
    }
}
