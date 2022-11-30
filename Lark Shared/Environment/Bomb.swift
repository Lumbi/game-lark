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
        physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.pickUp
        physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.terrain
        physicsBody?.density = 0.01
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
