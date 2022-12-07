//
//  Constants.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-09.
//

import Foundation
import CoreGraphics

struct Const {
    struct Node {
        struct Name {
            static let lander = "lander"
            static let spawn = "spawn"
            static let gem = "gem"
            static let depot = "depot"
            static let bomb = "bomb"
            static let spike = "spike"
            static let bumper = "bumper"
            static let outerBounds = "outer_bounds"
            static let innerBounds = "inner_bounds"
        }
        
        struct ZPosition {
            static let HUD: CGFloat = 9000
            static let visualEffects: CGFloat = 5000
            static let player: CGFloat = 4000
            static let interactive: CGFloat = 3000
        }
        
        struct Lander {
            static let collisionSpeedWarningThreshold: CGFloat = 120
            static let collisionSpeedDeathThreshold: CGFloat = 140
            static let outOfBoundsTimer: TimeInterval = 6
        }

        struct Bumper {
            static let force: CGFloat = 5
        }
    }
    
    struct PhysicsBody {
        static let gravity: CGVector = .init(dx: 0, dy: -0.8)
        
        struct Bitmask {
            static let all: UInt32 = 0xFFFFFFFF
            static let none: UInt32 = 0
            static let lander: UInt32 = 0x1 << 1
            static let terrain: UInt32 = 0x1 << 2
            static let collectible: UInt32 = 0x1 << 3
            static let trigger: UInt32 = 0x1 << 4
            static let innerBounds: UInt32 = 0x1 << 5
            static let outerBounds: UInt32 = 0x1 << 6
            static let transientCollectible: UInt32 = 0x1 << 7 // TODO: Rename this...
            static let bomb: UInt32 = 0x1 << 8
            static let shockwave: UInt32 = 0x1 << 9
            static let enemy: UInt32 = 0x1 << 10
            static let bumper: UInt32 = 0x1 << 11
        }
    }
    
    struct Layer {
        struct Property {
            static let collision = "collision"
        }
    }
    
    struct Tile {
        struct Property {
            static let destructible = "destructible"
        }
    }
    
    struct HUD {
        // TODO: Tweak these
        static func threshold(for distance: GemDetector.Distance) -> CGFloat {
            switch distance {
            case .immediate: return 100
            case .near: return 200
            case .far: return 400
            }
        }
    }
}
