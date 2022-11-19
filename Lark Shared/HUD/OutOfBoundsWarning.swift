//
//  OutOfBoundsWarning.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-17.
//

import Foundation
import SpriteKit

class OutOfBoundsWarning: SKNode {
    private(set) var visible: Bool = false
    
    override init() {
        super.init()
        
        let sprite = SKSpriteNode(imageNamed: "spr_warning")
        sprite.size = .init(width: 64, height: 64)
        addChild(sprite)
        
        let label = SKLabelNode(text: "LOSING CONNECTION")
        label.fontName = "Futura"
        label.fontSize = 18
        label.fontColor = .yellow
        label.verticalAlignmentMode = .top
        label.horizontalAlignmentMode = .center
        label.position = .init(x: 0, y: -32)
        addChild(label)
        
        zPosition = Const.Node.ZPosition.visualEffects
        
        alpha = 0
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
