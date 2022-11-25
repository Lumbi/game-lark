//
//  MissionTime.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-25.
//

import Foundation
import SpriteKit

class MissionTime: SKLabelNode {
    private var startTime: TimeInterval?
    private(set) var elapsedTime: TimeInterval = 0
    private var updateCheck: TimeAccumulator = .init(threshold: 1.0 / 12.0)
    private let formatter: MeasurementFormatter = .init()
    private var stopped: Bool = true
    
    override init() {
        super.init()
        fontName = "Menlo"
        fontSize = 18
        verticalAlignmentMode = .top
        horizontalAlignmentMode = .center

        formatter.numberFormatter.maximumFractionDigits = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        startTime = nil
        stopped = false
    }
    
    func stop() {
        stopped = true
    }
    
    func update(time: Time) {
        guard !stopped else { return }

        if startTime == nil {
            startTime = time.last
        }
        
        if let lastTime = time.last, let startTime = startTime {
            elapsedTime = lastTime - startTime
        }
        
        if updateCheck.update(time: time) {
            let hours = Int(floor(elapsedTime / 3600))
            let minutes = Int(floor(elapsedTime.truncatingRemainder(dividingBy: 3600) / 60))
            let seconds = Int(floor(elapsedTime.truncatingRemainder(dividingBy: 60)))
            let millis = Int(elapsedTime.truncatingRemainder(dividingBy: 1) * 1000)
            text = String(format: "MISSION TIME: %02d:%02d:%02d:%03d", hours, minutes, seconds, millis)
        }
    }
}
