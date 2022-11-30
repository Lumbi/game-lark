//
//  Hook.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-28.
//

import Foundation
import SpriteKit

class Hook: SKNode {
    private let parts: [SKNode]
    private var joints: [SKPhysicsJoint] = []
    
    override init() {
        parts = (0...10).map { _ in SKShapeNode(circleOfRadius: 1) }
        
        super.init()
    
        parts.enumerated().forEach { (i, part) in
            part.position = .init(x: 0, y: -i * 10)
            part.physicsBody = .init(circleOfRadius: 1)
            part.physicsBody?.density = 0.01
            part.physicsBody?.allowsRotation = true
            part.physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.none
            part.physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.none
        }
        
        for part in parts {
            addChild(part)
        }
    }
    
    func attach(from node: SKNode, to other: SKNode) {
        guard let scene = scene else { return }
        
        parts.enumerated().forEach { (i, part) in
            let isFirst = i == 0
            let isLast = i == parts.count - 1

            if isFirst {
                if
                    let bodyA = node.physicsBody,
                    let bodyB = part.physicsBody
                {
                    let joint = SKPhysicsJointLimit.joint(
                        withBodyA: bodyA,
                        bodyB: bodyB,
                        anchorA: scene.convert(.zero, from: node),
                        anchorB: scene.convert(.zero, from: part)
                    )
                    joint.maxLength = 10
                    joints.append(joint)
                }
                return
            }
            
            let previousPart = parts[i - 1]
            if
                let bodyA = previousPart.physicsBody,
                let bodyB = part.physicsBody
            {
                let joint = SKPhysicsJointLimit.joint(
                    withBodyA: bodyA,
                    bodyB: bodyB,
                    anchorA: scene.convert(.zero, from: previousPart),
                    anchorB: scene.convert(.zero, from: part)
                )
                joint.maxLength = 10
                joints.append(joint)
            }
            
            if isLast {
                if
                    let bodyA = part.physicsBody,
                    let bodyB = other.physicsBody
                {
                    let joint = SKPhysicsJointLimit.joint(
                        withBodyA: bodyA,
                        bodyB: bodyB,
                        anchorA: scene.convert(.zero, from: part),
                        anchorB: scene.convert(.zero, from: other)
                    )
                    joint.maxLength = 10
                    joints.append(joint)
                }
            }
        }
        
        joints.forEach { joint in
            scene.physicsWorld.add(joint)
        }
    }
    
    func teardownPhysics() {
        joints.forEach { joint in
            scene?.physicsWorld.remove(joint)
        }
        joints.removeAll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
