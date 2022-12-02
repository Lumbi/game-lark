//
//  LevelSelectViewController.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-24.
//

import Foundation
import UIKit
import SpriteKit

class LevelSelectViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapSelectLevel1() {
        transiton(to: PrototypeLevel1())
    }

    @IBAction func tapSelectLevel2() {
        transiton(to: PrototypeLevel2())
    }

    @IBAction func tapSelectLevel3() {
        transiton(to: PrototypeLevel3())
    }

    private func transiton(to level: LevelScene) {
        view.isUserInteractionEnabled = false

        UIView.animate(
            withDuration: 2,
            animations: {
                self.view.alpha = 0
            },
            completion: { _ in
                let viewController = GameViewController()
                viewController.level = level
                self.view.window?.rootViewController = viewController
            }
        )
    }
}
