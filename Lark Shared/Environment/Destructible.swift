//
//  SKTile+Destructible.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-30.
//

import Foundation
import SpriteKit
import SKTiled

extension SKTile {
    var isDestructible: Bool {
        tileData.properties[Const.Tile.Property.destructible] == "true"
    }
    
    func destroy() {
        removeFromParent()
    }
}
