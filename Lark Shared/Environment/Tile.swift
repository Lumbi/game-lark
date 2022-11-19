//
//  Tile.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit

/*
 Environment tile, can have a rigid body or not depending on the properties
 */

class Tile: SKNode {
    override init() {
        super.init()

        physicsBody = .init(rectangleOf: .init(width: 32, height: 32))
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = false
        
        addChild(
            SKShapeNode(rect: .init(
                origin: .init(x: -16, y: -16),
                size: .init(width: 32, height: 32)
            ))
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/*
 What about tiles that cause instant death? (lava, spikes)
 */
