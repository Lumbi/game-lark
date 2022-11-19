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
    private let gemsInCargoCounter: SKLabelNode = .init()
    private let gemsInDepotCounter: SKLabelNode = .init()
    
    override init() {
        super.init()

        gemsInCargoCounter.fontName = "Futura"
        gemsInCargoCounter.fontSize = 24
        gemsInCargoCounter.horizontalAlignmentMode = .left
        gemsInCargoCounter.verticalAlignmentMode = .top
        gemsInCargoCounter.text = "IN CARGO: 0 gems(s)"
        addChild(gemsInCargoCounter)
        
        gemsInDepotCounter.fontName = "Futura"
        gemsInDepotCounter.fontSize = 24
        gemsInDepotCounter.horizontalAlignmentMode = .left
        gemsInDepotCounter.verticalAlignmentMode = .top
        gemsInDepotCounter.text = "IN DEPOT: 0 gems(s)"
        gemsInDepotCounter.position.y = gemsInCargoCounter.position.y - 32
        addChild(gemsInDepotCounter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GemCounter: CargoDelegate {
    func cargoDidUpdate(_ cargo: Cargo) {
        gemsInCargoCounter.text = "IN CARGO: \(cargo.gemCount) gem(s)"
        if cargo.gemCount > 0 {
            gemsInCargoCounter.run(FX.bounce())
        }
    }
}

extension GemCounter: SharedDepotDelegate {
    func sharedDepotDidUpdate(_ sharedDepot: SharedDepot) {
        gemsInDepotCounter.text = "IN DEPOT: \(sharedDepot.gems.count) gem(s)"
        gemsInDepotCounter.run(FX.bounce())
    }
}
