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
        return CGSize(width: bottomRight.x - topLeft.x, height: topLeft.y - bottomRight.y)
    }
}
