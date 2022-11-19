//
//  HighSpeedWarning.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

class HighSpeedWarning: SKNode {
    private(set) var visible: Bool = true
    
    override init() {
        super.init()
        
        let sprite = SKSpriteNode(imageNamed: "spr_warning")
        sprite.size = .init(width: 32, height: 32)
        addChild(sprite)
        
        let label = SKLabelNode(text: "HIGH SPEED")
        label.fontName = "Futura"
        label.fontSize = 12
        label.fontColor = .yellow
        label.verticalAlignmentMode = .top
        label.horizontalAlignmentMode = .center
        label.position = .init(x: 0, y: -16)
        addChild(label)
        
        zPosition = Const.Node.ZPosition.visualEffects
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        guard !visible else { return }
        
        removeAllActions()
        run(
            .repeatForever(
                .sequence([
                    .fadeIn(withDuration: 0.2),
                    .fadeOut(withDuration: 0.2)
                ])
            )
        )
        
        visible = true
    }
    
    func hide() {
        guard visible else { return }

        removeAllActions()
        alpha = 0
        
        visible = false
    }
}
