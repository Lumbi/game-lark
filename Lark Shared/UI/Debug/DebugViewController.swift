//
//  DebugViewController.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-04.
//

import Foundation
import UIKit

class DebugViewController: UIViewController {
    @IBAction func tapCloseButton() {
        presentingViewController?.beginAppearanceTransition(true, animated: false)
        dismiss(animated: true)
        presentingViewController?.endAppearanceTransition()
    }

    @IBAction func tapResetProgressButton() {
        let progressService = ProgressService()
        progressService.reset()
    }
}
