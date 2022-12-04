//
//  Hook.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-28.
//

import Foundation
import SpriteKit

class Hook: SKNode {
    private var parts: [SKNode] = []
    private var joints: [SKPhysicsJoint] = []
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if joints.last?.bodyB.node?.parent == nil {
            isHidden = true
        }
    }

    var isAttached: Bool {
        joints.last?.bodyB != nil &&
        joints.last?.bodyB.node != nil &&
        joints.last?.bodyB.node?.parent != nil
    }

    var attachedNode: SKNode? {
        joints.last?.bodyB.node
    }
    
    func attach(from node: SKNode, to other: SKNode) {
        guard let scene = scene else { return }

        teardownPhysics()

        parts = (0...10).map { i in
            let part = SKShapeNode(circleOfRadius: 1)
//            part.position = .init(x: 0, y: -i * 10)
            part.position = .zero
            part.physicsBody = .init(circleOfRadius: 1)
            part.physicsBody?.density = 0.01
            part.physicsBody?.allowsRotation = true
            part.physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.none
            part.physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.none
            return part
        }

        for part in parts { addChild(part) }

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

        other.zPosition += 1 // Bump Z position so that it's visible againts same type of nodes
    }
    
    func teardownPhysics() {
        for joint in joints { scene?.physicsWorld.remove(joint) }
        joints.removeAll()

        for part in parts { part.removeFromParent() }
        parts.removeAll()
    }
}
