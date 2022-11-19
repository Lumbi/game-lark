//
//  Goal.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit

/*
 The player can collect all gems within an area and find the goal to deposit the gems.
 
 The player must remain at least 1 seconds without moving inside the goal to deposit the gems.
 
 Also serves as a spawn location / checkpoint.
 */

class Depot: SKNode {
    weak var delegate: DepotDelegate? = nil
    
    private let sprite: SKShapeNode = .init(circleOfRadius: 32)
    private let gauge: SKShapeNode  = .init(circleOfRadius: 32)
    
    private let depositGemAction: SKAction = .scale(to: 1, duration: 3)
    
    
    override init() {        
        super.init()

        name = Const.Node.Name.depot
        
        let body = SKNode()
        body.physicsBody = .init(rectangleOf: .init(width: 32, height: 32))
        body.physicsBody?.affectedByGravity = false
        body.physicsBody?.isDynamic = false
        body.physicsBody?.allowsRotation = false
        body.physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.trigger
        body.physicsBody?.collisionBitMask = 0
        body.physicsBody?.contactTestBitMask = Const.PhysicsBody.Bitmask.lander
        addChild(body)
        
        addChild(sprite)
        sprite.fillColor = .green.withAlphaComponent(0.5)

        gauge.fillColor = .green
        gauge.setScale(0)
        addChild(gauge)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startGemDeposit() {
        gauge.setScale(0)
        gauge.run(depositGemAction) { [weak self] in
            if let self = self {
                self.delegate?.depotReadyToAcceptGems(self)
            }
        }
    }
    
    func acceptGems(_ gems: [Gem]) {
        // TODO:
    }
    
    func cancelGemDeposit() {
        gauge.removeAllActions()
        gauge.setScale(0)
    }
}

protocol DepotDelegate: AnyObject {
    func depotReadyToAcceptGems(_ depot: Depot)
}
