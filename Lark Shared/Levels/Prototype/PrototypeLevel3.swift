//
//  PrototypeLevel3.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-02.
//

import Foundation
import SpriteKit

class PrototypeLevel3: LevelScene {
    override var levelName: LevelName { .w1_l3 }

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
                .init(text: "OK, this is the last site."),
                .init(text: "Hmm, there's explosives lying around."),
                .init(text: "Tooks like someone's been here before us..."),
                .init(text: "Well, maybe you could make use of it."),
                .init(text: "You should be able to grab some with your hook and move it around. Give it a try."),
                .init(text: "Wait, there's some kind of miscalculation."),
                .init(text: "The probe got deployed at the wrong spot."),
                .init(text: "The shard depot shouldn't be too far though. You'll have look around to find it."),
            ])
        }
    }

    override func presentComplete() {
        presentMessages([
            .init(text: "Easy peasy."),
            .init(text: "I'm worried about the explosives left behind though."),
            .init(text: "If someone's been sniffing around for Topsium before us, that could breed trouble."),
            .init(text: "You know as well as I do what could happen if enough of that stuff falls in the wrong hands..."),
            .init(text: "We better hurry up, let's get the probe out of here."),
        ]) { [weak self] in
            let viewController = MissionCompleteViewController.fromNib()
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.modalTransitionStyle = .crossDissolve

            self?.view?.window?.rootViewController?.present(viewController, animated: true)
        }
    }
}
