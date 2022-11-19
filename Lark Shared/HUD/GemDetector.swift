//
//  Radar.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit

class GemDetector: SKNode {
    enum Distance {
        case far
        case near
        case immediate
    }
    
    private let sprite: SKSpriteNode = .init()
    private let bleepAnimation: SKAction
    
    override init() {
        let atlas = SKTextureAtlas(named: "spr_radar")
        let frames = atlas.textureNames.sorted().map { atlas.textureNamed($0) }
        bleepAnimation = SKAction.animate(with: frames, timePerFrame: 1.0 / 8.0)
        
        super.init()
        
        zPosition = Const.Node.ZPosition.HUD
        
        sprite.size = .init(width: 64, height: 64)
        sprite.colorBlendFactor = 1
        addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ distance: Distance) {
        alpha = 1
        sprite.removeAllActions()
        
        let waitDuration: TimeInterval
        let tintColor: UIColor
        
        switch distance {
        case .far:
            waitDuration = 2
            tintColor = .systemTeal
        case .near:
            waitDuration = 0.7
            tintColor = .systemYellow
        case .immediate:
            waitDuration = 0
            tintColor = .systemRed
        }
        
        sprite.color = tintColor

        sprite.run(
            .repeatForever(
                .sequence([
                    bleepAnimation,
                    .wait(forDuration: waitDuration)
                ])
            )
        )
    }
    
    func hide() {
        alpha = 0
        sprite.removeAllActions()
    }
}
