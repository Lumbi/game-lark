//
//  DebugViewController.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-04.
//

import Foundation
import UIKit

class DebugViewController: UIViewController {
    private let progressService = ProgressService()

    @IBAction func tapCloseButton() {
        presentingViewController?.beginAppearanceTransition(true, animated: false)
        dismiss(animated: true)
        presentingViewController?.endAppearanceTransition()
    }

    @IBAction func tapResetProgressButton() {
        progressService.reset()
    }

    @IBAction func tapCompleteAllProgressButton() {
        progressService.complete(levelName: .w1_l1)
        progressService.complete(levelName: .w1_l2)
        progressService.complete(levelName: .w1_l3)
    }
}
