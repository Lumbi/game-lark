//
//  Lander.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit

class Lander: SKNode {
    private var thrusterEmitRate: CGFloat = 0

    let leftTruster = Thruster(direction: .init(dx: 2, dy: 3).unit)
    let rightTruster = Thruster(direction: .init(dx: -2, dy: 3).unit)
    
    private let leftThrusterEmitter: SKEmitterNode = .init(fileNamed: "LanderThruster")!
    private let rightThrusterEmitter: SKEmitterNode = .init(fileNamed: "LanderThruster")!
    private let highSpeedWarning: HighSpeedWarning = .init()
    
    weak var telemetricDataDelegate: LanderTelemetricDataDelegate? = nil
    
    private(set) var lastSpeed: CGFloat = 0

    // TODO: Refactor to move to LanderBoundsContactHandler or something
    var levelBoundsExitPosition: CGPoint? = nil
    
    override init() {
        super.init()
        name = Const.Node.Name.lander
        
        physicsBody = .init(circleOfRadius: 16, center: .zero)
        physicsBody?.affectedByGravity = true
        physicsBody?.density = 0.5
        physicsBody?.allowsRotation = false
        physicsBody?.friction = 0.1
        physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.lander
        physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.terrain
        physicsBody?.contactTestBitMask = Const.PhysicsBody.Bitmask.collectible | Const.PhysicsBody.Bitmask.trigger | Const.PhysicsBody.Bitmask.terrain
        
//        addChild(SKShapeNode(circleOfRadius: 16))
        
        thrusterEmitRate = leftThrusterEmitter.particleBirthRate
        
        leftTruster.position = .init(x: -8, y: 0)
        leftTruster.release()
//        leftThrusterEmitter.emissionAngle = (270 - 45) * CGFloat.pi / 180
        addChild(leftTruster)
        
        rightTruster.position = .init(x: 8, y: 0)
        rightTruster.release()
//        rightThrusterEmitter.emissionAngle = (270 + 45) * CGFloat.pi / 180
        addChild(rightTruster)
        
        addChild(SKSpriteNode(imageNamed: "spr_lander"))

        highSpeedWarning.position = .init(x: 48, y: 48)
        addChild(highSpeedWarning)
        highSpeedWarning.show()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(time: Time) {
        if let velocity = physicsBody?.velocity {
            telemetricDataDelegate?.didUpdate(velocity: velocity)
            
            lastSpeed = velocity.length
            
            if lastSpeed > Const.Node.Lander.collisionSpeedWarningThreshold {
                highSpeedWarning.show()
            } else {
                highSpeedWarning.hide()
            }
        }
    }
}

class Thruster: SKNode {
    var enabled: Bool = true

    private let direction: CGVector
    private var firing: Bool = false
    private let force: CGFloat = 8
    
    private let emitter: SKEmitterNode = .init(fileNamed: "LanderThruster")!
    
    init(direction: CGVector) {
        self.direction = direction
        super.init()
        if direction.dx < 0 {
            emitter.emissionAngle = atan(direction.dy / direction.dx)
        } else {
            emitter.emissionAngle = atan(direction.dy / direction.dx) + CGFloat.pi
        }
        addChild(emitter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire() {
        guard enabled else { return }

        firing = true
        emitter.particleBirthRate = 80
    }
    
    func release() {
        firing = false
        emitter.particleBirthRate = 0
    }
    
    func apply(on lander: Lander?) {
        if enabled && firing {
            lander?.physicsBody?.applyForce(force * direction)
        }
    }
}

protocol LanderTelemetricDataDelegate: AnyObject {
    func didUpdate(velocity: CGVector)
}
