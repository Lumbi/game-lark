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
    var progressService: ProgressService = .init()

    @IBOutlet weak var selectLevel1Button: UIButton?
    @IBOutlet weak var selectLevel2Button: UIButton?
    @IBOutlet weak var selectLevel3Button: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateLevelButtonsAvailability()

        if animated {
            view.alpha = 0
            UIView.animate(
                withDuration: 1,
                animations: {
                    self.view.alpha = 1
                }
            )
        }
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

    @IBAction func showDebug() {
        #if DEBUG
        let viewController = DebugViewController.fromNib()
        present(viewController, animated: true)
        #endif
    }

    private func transiton(to level: LevelScene) {
        view.isUserInteractionEnabled = false

        UIView.animate(
            withDuration: 1,
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

    private func updateLevelButtonsAvailability() {
        if let selectLevel1Button = selectLevel1Button,
           let selectLevel2Button = selectLevel2Button,
           let selectLevel3Button = selectLevel3Button
        {
            updateLevelButtonAvailability(
                for: selectLevel1Button,
                progress: progressService.progress(for: .w1_l1)
            )

            updateLevelButtonAvailability(
                for: selectLevel2Button,
                progress: progressService.progress(for: .w1_l2)
            )

            updateLevelButtonAvailability(
                for: selectLevel3Button,
                progress: progressService.progress(for: .w1_l3)
            )
        }
    }

    private func updateLevelButtonAvailability(for button: UIButton, progress: LevelProgress) {
        switch progress {
        case .locked:
            button.isEnabled = false
            button.tintColor = .blue
        case .unlocked:
            button.isEnabled = true
            button.tintColor = .blue
        case .completed:
            button.isEnabled = true
            button.tintColor = .green
        }
    }
}
