//
//  CollisionHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

protocol ContactHandler {
    var level: LevelScene { get }
    var successor: ContactHandler? { get }

    func handle(contact: SKPhysicsContact)
}
