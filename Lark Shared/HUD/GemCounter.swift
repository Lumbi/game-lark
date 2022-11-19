//
//  GemCounter.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit

/*
 Displays the number of gem found so far.
 */

class GemCounter: SKNode {
    private let label: SKLabelNode = .init()
    
    override init() {
        super.init()

        label.fontName = "Futura"
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .top
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GemCounter: CargoDelegate {
    func cargoDidUpdate(_ cargo: Cargo) {
        label.text = "IN CARGO: \(cargo.gemCount) gem(s)"
    }
}
