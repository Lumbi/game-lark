//
//  SKNode+Ext.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

extension SKNode {
    func parent<T: SKNode>(ofType type: T.Type) -> T? {
        if parent is T {
            return parent as? T
        } else if parent == nil{
            return nil
        } else {
            return parent?.parent(ofType: type)
        }
    }
}
