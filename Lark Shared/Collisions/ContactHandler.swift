//
//  CollisionHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

protocol ContactHandler {
    var successor: ContactHandler? { get }

    func handle(contact: SKPhysicsContact)
}

struct ContactHandlerChain {
    var first: ContactHandler
    
    func handle(contact: SKPhysicsContact) {
        var current: ContactHandler? = first
        
        while current != nil {
            current?.handle(contact: contact)
            current = current?.successor
        }
    }
}
