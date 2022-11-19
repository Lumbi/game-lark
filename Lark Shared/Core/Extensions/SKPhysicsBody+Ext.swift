//
//  SKPhysicsBody.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

extension SKPhysicsBody {
    func parentNode<T: SKNode>(ofType type: T.Type) -> T? {
        if node is T {
            return node as? T
        } else if node == nil {
            return nil
        } else {
            return node?.parent(ofType: type)
        }
    }
}
