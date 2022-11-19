//
//  MissionCompleteViewController.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-16.
//

import Foundation
import UIKit

class MissionCompleteViewController: UIViewController {
    @IBOutlet var completeButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeButton?.setTitle(localized("menu/complete_mission"), for: .normal)
    }
    
    @IBAction func tapCompleteButton() {
        // TODO: go to level selection screen?
    }
}
