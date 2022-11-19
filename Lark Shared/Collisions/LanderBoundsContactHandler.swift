//
//  LanderBoundsContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-17.
//

import Foundation
import SpriteKit

struct BeginLanderBoundsContactHandler: ContactHandler {
    let scene: GameScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        if contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.outerBounds
        ) {
            scene.hud.outOfBoundsWarning.hide()
            scene.cameraControl.follow = true
            scene.cancelOutOfBoundsCountDown()
        }
    }
}

struct EndLanderBoundsContactHandler: ContactHandler {
    let scene: GameScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        if contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.outerBounds
        ) {
            scene.hud.outOfBoundsWarning.show()
            scene.cameraControl.follow = false
            scene.startOutOfBoundsCountDown()

        } else if contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.innerBounds
        ) {
            scene.dropGemsFromCargo()
        }
    }
}
