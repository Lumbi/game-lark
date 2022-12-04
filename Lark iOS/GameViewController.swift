//
//  GameViewController.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var level: LevelScene?

    override func loadView() {
        super.loadView()
        
        view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present the scene
        let skView = self.view as! SKView

        if let level = level {
            skView.presentScene(level)
        } else {
            print("Error: 'level' was not set on GameViewController before it was loaded")
        }
        
        skView.ignoresSiblingOrder = true
        
        #if DEBUG
        skView.showsFPS = true
        skView.showsNodeCount = true
        #endif
        
        skView.isMultipleTouchEnabled = true
        
        modalPresentationStyle = .fullScreen

        level?.start()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        level?.hud.layout()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
}
