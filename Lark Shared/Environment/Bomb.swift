//
//  PickUp.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-29.
//

import Foundation
import SpriteKit

class Bomb: SKNode {
    private let sprite: SKSpriteNode
    
    override init() {
        let size = CGSize(width: 32, height: 32)
        sprite = SKSpriteNode(imageNamed: "spr_bomb")
        
        super.init()
        
        name = Const.Node.Name.bomb
        
        sprite.size = size
        addChild(sprite)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.bomb
        physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.terrain
        physicsBody?.contactTestBitMask = Const.PhysicsBody.Bitmask.terrain
        physicsBody?.density = 0.01
        
        zPosition = Const.Node.ZPosition.player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func engage() {
        sprite.run(
            .sequence([
                FX.blink(color: .red, times: 5, speed: 2),
                FX.blink(color: .red, times: 10, speed: 1),
                FX.blink(color: .red, times: 10, speed: 0.3),
                .run { self.explode() }
            ])
        )
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
