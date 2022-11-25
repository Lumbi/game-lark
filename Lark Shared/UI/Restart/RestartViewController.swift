//
//  RestartView.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-13.
//

import Foundation
import UIKit
import SpriteKit

class RestartViewController: UIViewController {
    @IBOutlet private var restartButton: UIButton?
    @IBOutlet private var quitButton: UIButton?
    
    // TODO: Instead of accessing scene directly, should just forward the callbacks and let scene handle the logic
    weak var scene: LevelScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restartButton?.setTitle(localized("menu/restart"), for: .normal)
        quitButton?.setTitle(localized("menu/quit"), for: .normal)
    }
    
    @IBAction func tapRestartButton() {
        dismiss(animated: true)
        scene?.redeployLanderToLastCheckpoint()
    }
    
    @IBAction func tapQuitButton() {
        scene?.abortMission()
    }
}
