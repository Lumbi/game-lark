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
    @IBOutlet weak var selectLevel4Button: UIButton?
    @IBOutlet weak var selectLevel5Button: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        progressService.load()
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

    @IBAction func tapSelectLevel4() {
        transiton(to: PrototypeLevel4())
    }

    @IBAction func tapSelectLevel5() {
        transiton(to: PrototypeLevel5())
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
        updateLevelButtonAvailability(for: selectLevel1Button, progress: progressService.progress(for: .w1_l1))
        updateLevelButtonAvailability(for: selectLevel2Button, progress: progressService.progress(for: .w1_l2))
        updateLevelButtonAvailability(for: selectLevel3Button, progress: progressService.progress(for: .w1_l3))
        updateLevelButtonAvailability(for: selectLevel4Button, progress: progressService.progress(for: .w1_l4))
        updateLevelButtonAvailability(for: selectLevel5Button, progress: progressService.progress(for: .w1_l5))
    }

    private func updateLevelButtonAvailability(for button: UIButton?, progress: LevelProgress) {
        guard let button = button else { return }
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
