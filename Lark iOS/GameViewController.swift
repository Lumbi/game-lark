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
    
    override func loadView() {
        super.loadView()
        
        view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = LevelScene.load(levelNamed: "level1")
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        modalPresentationStyle = .fullScreen
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
