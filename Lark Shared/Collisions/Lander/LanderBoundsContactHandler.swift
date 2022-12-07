//
//  LanderBoundsContactHandler.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-17.
//

import Foundation
import SpriteKit

struct BeginLanderBoundsContactHandler: ContactHandler {
    let level: LevelScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        if contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.outerBounds
        ) {
            level.hud.outOfBoundsWarning.hide()
            level.cameraControl.follow = true
            level.cancelOutOfBoundsCountDown()
        }
    }
}

struct EndLanderBoundsContactHandler: ContactHandler {
    let level: LevelScene
    let successor: ContactHandler?
    
    func handle(contact: SKPhysicsContact) {
        if contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.outerBounds
        ) {
            level.hud.outOfBoundsWarning.show()
            level.cameraControl.follow = false
            level.startOutOfBoundsCountDown()

        } else if contact.isBetween(
            Const.PhysicsBody.Bitmask.lander,
            Const.PhysicsBody.Bitmask.innerBounds
        ) {
            let landerPosition = level.convert(.zero, from: level.lander)
            level.lander.levelBoundsExitPosition = landerPosition
            level.dropGemsFromCargo(at: landerPosition)
        }
    }
}
