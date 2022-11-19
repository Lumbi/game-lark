//
//  SKCameraNode+Ext.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

extension SKCameraNode {
    var size: CGSize {
        guard let scene = scene, let view = scene.view else { return .zero }
        let topLeft = convert(scene.convertPoint(fromView: view.bounds.topLeft), from: scene)
        let bottomRight = convert(scene.convertPoint(fromView: view.bounds.bottomRight), from: scene)
        let width = bottomRight.x - topLeft.x
        let height = topLeft.y - bottomRight.y
        
        // HACK: Need a better way to deal with orientation
        if width < height { // in landscape
            return CGSize(width: height, height: width)
        } else { // in portrait
            return CGSize(width: width, height: height)
        }
    }
}
