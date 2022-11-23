//
//  Goal.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit

class Depot: SKNode {
    weak var delegate: DepotDelegate? = nil
    weak var sharedDepot: SharedDepot? = nil
    
    private let sprite: SKSpriteNode = .init(imageNamed: "spr_depot")
    private let gauge: DepotGauge = .init()
    
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
        
        sprite.size = .init(width: 64, height: 64)
        sprite.zPosition = Const.Node.ZPosition.interactive
        addChild(sprite)

        gauge.position = .init(x: 32 + 16, y: 0)
        addChild(gauge)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startGemDeposit() {
        gauge.animateToFill { [weak self] in
            if let self = self {
                self.delegate?.depotReadyToAcceptGems(self)
            }
        }
    }
    
    func acceptGems(_ gems: [Gem]) {
        sharedDepot?.deposit(gems)
    }
    
    func cancelGemDeposit() {
        gauge.cancelFillAnimation()
    }
}

protocol DepotDelegate: AnyObject {
    func depotReadyToAcceptGems(_ depot: Depot)
}

class DepotGauge: SKNode {
    private static let width: CGFloat = 16
    private static let height: CGFloat = 64
    
    private let gaugeFrame: SKShapeNode = .init(rectOf: .init(width: DepotGauge.width, height: DepotGauge.height))
    private let gaugeFill: SKNode = .init()
    
    override init() {
        super.init()
        
        gaugeFrame.zPosition = Const.Node.ZPosition.interactive + 1
        gaugeFrame.lineWidth = 2
        addChild(gaugeFrame)
        
        let gaugeFillShape = SKShapeNode(rectOf: .init(width: DepotGauge.width, height: DepotGauge.height))
        gaugeFillShape.fillColor = .green
        gaugeFill.addChild(gaugeFillShape)
        gaugeFill.zPosition = Const.Node.ZPosition.interactive
        
        gaugeFillShape.position = .init(x: DepotGauge.width / 2.0, y: DepotGauge.height / 2.0)
        gaugeFill.position = .init(x: -DepotGauge.width / 2.0, y: -DepotGauge.height / 2.0)
        addChild(gaugeFill)
        
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateToFill(_ completion: @escaping () -> Void) {
        gaugeFill.yScale = 0
        let gaugeFillAnimation = SKAction.sequence([
            .scaleY(to: 1, duration: 3),
            .repeat(
                .sequence([
                    .fadeOut(withDuration: 0.1),
                    .fadeIn(withDuration: 0.1),
                ]),
                count: 3
            )
        ])
        gaugeFill.run(gaugeFillAnimation)
        
        alpha = 0
        run(
            .sequence([
                .fadeIn(withDuration: 0.2),
                .wait(forDuration: gaugeFillAnimation.duration),
                .fadeOut(withDuration: 0.2)
            ])
        ) {
            completion()
        }
    }
    
    func cancelFillAnimation() {
        removeAllActions()
        gaugeFill.removeAllActions()

        run(.fadeOut(withDuration: 0.2))
    }
}
