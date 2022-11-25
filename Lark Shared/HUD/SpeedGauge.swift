//
//  SpeedGauge.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-14.
//

import Foundation
import SpriteKit

class SpeedGauge: SKNode {
    private let label: SKLabelNode = .init()
    
    override init() {
        super.init()
        
        label.horizontalAlignmentMode = .right
        label.verticalAlignmentMode = .top
        label.fontName = "Menlo"
        label.fontSize = 18
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpeedGauge: LanderTelemetricDataDelegate {
    func didUpdate(velocity: CGVector) {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        label.text = formatter.string(from: .init(value: Double(velocity.length) / 10.0, unit: UnitSpeed.metersPerSecond))
    }
}
