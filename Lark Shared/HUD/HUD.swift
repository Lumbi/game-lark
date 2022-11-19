//
//  HUD.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-09.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    let gemCounter: GemCounter = .init()
    let speedGauge: SpeedGauge = .init()
    let gemDetector: GemDetector = .init()
    
    override init() {
        super.init()
        
        addChild(gemCounter)
        addChild(speedGauge)
        addChild(gemDetector)
    }
    
    func layout() {
        guard let camera = scene?.camera else { return }

        gemCounter.position = .init(x: -camera.size.halfWidth, y: camera.size.halfHeight).applying(.init(translationX: 16, y: -16))
        speedGauge.position = .init(x: camera.size.halfWidth, y: camera.size.halfHeight).applying(.init(translationX: -16, y: -16))
        gemDetector.position = .init(x: camera.size.halfWidth - 128, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
