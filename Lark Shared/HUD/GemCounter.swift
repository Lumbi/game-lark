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
        addChild(gemsInCargoCounter)
        
        gemsInDepotCounter.fontName = "Futura"
        gemsInDepotCounter.fontSize = 24
        gemsInDepotCounter.horizontalAlignmentMode = .left
        gemsInDepotCounter.verticalAlignmentMode = .top
        gemsInDepotCounter.position.y = gemsInCargoCounter.position.y - 32
        addChild(gemsInDepotCounter)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GemCounter: CargoDelegate {
    func cargoDidUpdate(_ cargo: Cargo) {
        gemsInCargoCounter.text = "IN CARGO: \(cargo.gemCount) shards"
        if cargo.gemCount > 0 {
            gemsInCargoCounter.run(FX.bounce())
        }
    }
}

extension GemCounter: SharedDepotDelegate {
    func sharedDepotDidUpdate(_ sharedDepot: SharedDepot) {
        updateGemsInDepotCounterText(sharedDepot.gems.count)
        if sharedDepot.gems.count > 0 {
            gemsInDepotCounter.run(FX.bounce())
        }
    }
    
    private func updateGemsInDepotCounterText(_ count: Int) {
        if let scene = scene as? LevelScene {
            gemsInDepotCounter.text = "IN DEPOT: \(count) / \(scene.detectedGemCount) shards"
        } else {
            gemsInDepotCounter.text = nil
        }
    }
}
