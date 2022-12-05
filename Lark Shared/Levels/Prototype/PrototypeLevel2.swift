//
//  PrototypeLevel2.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-02.
//

import Foundation
import SpriteKit

class PrototypeLevel2: LevelScene {
    override var levelName: LevelName { .w1_l2 }

    override func didStart() {
        super.didStart()

        self.presentIntro()
    }

    // MARK: - Dialogs

    func presentIntro() {
        view?.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view?.isUserInteractionEnabled = true
            self.presentMessages([
                .init(text: "Alright command module, time for another sweep."),
                .init(text: "There's a few more Topsium shard on this site. Good luck.")
            ])
        }
    }

    override func presentComplete() {
        presentMessages([
            .init(text: "Good stuff. Looks like we're done here.")
        ]) { [weak self] in
            let viewController = MissionCompleteViewController.fromNib()
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.modalTransitionStyle = .crossDissolve

            self?.view?.window?.rootViewController?.present(viewController, animated: true)
        }
    }
}
