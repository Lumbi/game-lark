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
            static let gem = "gem"
            static let depot = "depot"
            static let spawn = "spawn"
            static let outerBounds = "outer_bounds"
            static let innerBounds = "inner_bounds"
        }
        
        struct ZPosition {
            static let HUD: CGFloat = 9000
            static let visualEffects: CGFloat = 5000
            static let interactive: CGFloat = 3000
        }
        
        struct Lander {
            static let collisionSpeedWarningThreshold: CGFloat = 120
            static let collisionSpeedDeathThreshold: CGFloat = 140
            static let outOfBoundsTimer: TimeInterval = 6
        }
    }
    
    struct PhysicsBody {
        static let gravity: CGVector = .init(dx: 0, dy: -0.8)
        
        struct Bitmask {
            static let all: UInt32 = 0xFFFFFFFF
            static let lander: UInt32 = 0x1 << 1
            static let terrain: UInt32 = 0x1 << 2
            static let collectible: UInt32 = 0x1 << 3
            static let trigger: UInt32 = 0x1 << 4
            static let innerBounds: UInt32 = 0x1 << 5
            static let outerBounds: UInt32 = 0x1 << 6
            static let transientCollectible: UInt32 = 0x1 << 7 // TODO: Rename this...
        }
    }
    
    struct Layer {
        struct Property {
            static let collision = "collision"
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
