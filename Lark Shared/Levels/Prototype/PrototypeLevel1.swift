//
//  PrototypeLevel1.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-02.
//

import Foundation
import SpriteKit

class PrototypeLevel1: LevelScene {
    override var levelName: LevelName { .w1_l1 }

    private var didShowIntro2: Bool = false
    private var intro2Check: TimeAccumulator = .init(threshold: 1)

    override func didStart() {
        super.didStart()

        view?.isUserInteractionEnabled = false
        lander.physicsBody?.isDynamic = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view?.isUserInteractionEnabled = true
            self.presentIntro1()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        if !didShowIntro2 {

            let didUseThrusters =
            lander.leftTruster.firedCount > 0 &&
            lander.leftTruster.releasedCount > 0 &&
            lander.rightTruster.firedCount > 0 &&
            lander.rightTruster.releasedCount > 0

            if didUseThrusters {
                if intro2Check.update(time: time) {
                    didShowIntro2 = true
                    presentIntro2()
                }
            }
        }
    }

    override func presentComplete() {
        presentMessages([
            .init(text: "Nice work. The spectrometer isn't picking up any signal now."),
            .init(text: "Looks like you've found all the Topsium shards around here."),
            .init(text: "Hang tight while we initiate the orbit sequence. Let's get the probe back home.")
        ]) { [weak self] in
            let viewController = MissionCompleteViewController.fromNib()
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.modalTransitionStyle = .crossDissolve

            self?.view?.window?.rootViewController?.present(viewController, animated: true)
        }
    }
}

// MARK: - Dialogs

extension PrototypeLevel1 {
    func presentIntro1() {
        presentMessages([
            .init(text: "Mission control to command module, do you copy?"),
            .init(text: "Excellent, telemetry data is looking nominal. Let's initiate the control check sequence."),
            .init(text: "Can you operate your control screen and test the lateral thrusters?")
        ])
    }

    func presentIntro2() {
        presentMessages([
            .init(text: "Lateral thrusters are looking good."),
            .init(text: "But, since you don't have that many flight hours on record let's go over the probe's controls."),
            .init(text: "To manoeuvre the probe, you'll need to balance the lateral thrusters carefully."),
            .init(text: "It's a bit more difficult than in the simulator."),
            .init(text: "The probe is also very fragile. Engineering had to cut some corners..."),
            .init(text: "Thankfully, we had enough budget for a velocity sensor, so you'll see when you're going too fast."),
            .init(text: "Also, you'll have to be careful not to stray too far away from the site."),
            .init(text: "Otherwise we'll lose connection to the probe. It's programmed to self-destruct in that case."),
            .init(text: "..."),
            .init(text: "Please be careful with the probe. These aren't free and I'd really like to keep budget for coffee here..."),
            .init(text: "Now, for the mission briefing, you'll need to retrieve shards of Tospium scattered on the site."),
            .init(text: "Tospium emits light at very specific wavelengths so you should be able to detect with the onboard spectrometer."),
            .init(text: "We've detected \(detectedGemCount) Topsium shards on this site."),
            .init(text: "Once you've collected the shards, just return them to the depot near the probe and we'll be done here."),
            .init(text: "Alright, enough chatting. The probe is all yours now, good luck."),
        ]) {
            self.hud.missionTime.start()
            self.lander.physicsBody?.isDynamic = true
        }
    }
}
