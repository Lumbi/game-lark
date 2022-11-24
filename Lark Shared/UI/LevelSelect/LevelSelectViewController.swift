//
//  LevelSelectViewController.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-24.
//

import Foundation
import UIKit

class LevelSelectViewController: UIViewController {
    
    @IBOutlet weak var selectLevelButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLevelButton?.setTitle(localized("level_select/select"), for: .normal)
    }
    
    @IBAction func tapSelectLevel() {
        view.isUserInteractionEnabled = false

        UIView.animate(
            withDuration: 2,
            animations: {
                self.view.alpha = 0
            },
            completion: { _ in
                self.view.window?.rootViewController = GameViewController()
            }
        )
    }
}
