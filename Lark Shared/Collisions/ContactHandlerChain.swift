//
//  ContactHandlerChain.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-06.
//

import Foundation
import SpriteKit

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

extension ContactHandlerChain {
    static func begin(for level: LevelScene) -> Self {
        ContactHandlerChain(
            first: LanderGemContactHandler(
                level: level,
                successor: BeginLanderDepotContactHandler(
                    level: level,
                    successor: LanderTerrainContactHandler(
                        level: level,
                        successor: BeginLanderBoundsContactHandler(
                            level: level,
                            successor: BombTerrainContactHandler(
                                level: level,
                                successor: ShockwaveTerrainContactHandler(
                                    level: level,
                                    successor: LanderBombContactHandler(
                                        level: level,
                                        successor: LanderEnemyContactHandler(
                                            level: level,
                                            successor: LanderBumpberContactHandler(
                                                level: level,
                                                successor: nil
                                        ))))))))))
    }

    static func end(for level: LevelScene) -> Self {
        ContactHandlerChain(
            first: EndLanderDepotContactHandler(
                level: level,
                successor: EndLanderBoundsContactHandler(
                    level: level,
                    successor: nil
                )))
    }
}
