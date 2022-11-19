//
//  FX.Explosion.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-13.
//

import Foundation
import SpriteKit

extension FX {
    class Explosion: SKNode {
        private let sprite: SKSpriteNode = .init()
        private let animation: SKAction
        
        override init() {
            sprite.size = .init(width: 128, height: 128)
            
            let atlas = SKTextureAtlas(named: "spr_explosion")
            let frames = atlas.textureNames.sorted().map { atlas.textureNamed($0) }
            animation = SKAction.animate(with: frames, timePerFrame: 1.0 / 60.0)

            super.init()
            
            zPosition = Const.Node.ZPosition.visualEffects
            
            addChild(sprite)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        static func play(in scene: SKScene, at position: CGPoint) {
            let explosion = Explosion()
            explosion.position = position
            scene.addChild(explosion)

            explosion.sprite.run(explosion.animation) {
                explosion.removeFromParent()
            }
        }
    }
}
