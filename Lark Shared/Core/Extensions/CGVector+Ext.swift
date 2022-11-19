//
//  CGVector+Ext.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import CoreGraphics

// MARK: - Properties

extension CGVector {
    var length: CGFloat {
        sqrt(dx * dx + dy * dy)
    }
    
    var unit: CGVector {
        let len = length
        return len > 0 ? (self * (1.0 / len)) : CGVector.zero
     }
}

// MARK: - Scalar Multiplication

func * (vector: CGVector, scalar: CGFloat) -> CGVector {
  return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

func * (scalar: CGFloat, vector: CGVector) -> CGVector {
  return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}
