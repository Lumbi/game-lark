//
//  Camera.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit

class CameraControl {
    var camera: SKCameraNode? = nil
    
    private let maxSpeed: CGFloat = 50000
    
    func follow(target: SKNode, duration: CGFloat, time: Time) {
        guard
            let camera = camera,
            camera.parent != nil,
            target.parent != nil,
            let destination = camera.scene?.convert(.zero, from: target)
        else { return }

        let dx = destination.x - camera.position.x
        let dy = destination.y - camera.position.y
        
        let epsilon = 0.1
        if abs(dx) < epsilon, abs(dy) < epsilon { return } // skip if near enough target
        
        let direction = CGVector(dx: dx, dy: dy).unit
        let speedX = min(dx * dx, maxSpeed) * time.delta
        let speedY = min(dy * dy, maxSpeed) * time.delta
        
        camera.position.x += direction.dx * speedX * time.delta
        camera.position.y += direction.dy * speedY * time.delta
    }
    
    func jump(to target: SKNode) {
        guard
            let camera = camera,
            let destination = camera.scene?.convert(.zero, from: target)
        else { return }

        camera.position = destination
    }
}
