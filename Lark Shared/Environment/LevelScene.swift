//
//  GameScene.swift
//  Lark Shared
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import SpriteKit
import SKTiled

class LevelScene: SKScene {
    let lander: Lander = .init()
    let cargo: Cargo = .init()
    let hud: HUD = .init()
    let landerControl: LanderControl = .init()
    let cameraControl: CameraControl = .init()
    let sharedDepot: SharedDepot = .init()

    private var levelName: String = ""
    private var time: Time = .init()
    private(set) var detectedGemCount: Int = 0
    
    // TODO: Future me, please refactor
    var didUseLeftThrusterAtLeastOnce: Bool = false
    var didUseRightThrusterAtLeastOnce: Bool = false
    var didShowIntro2: Bool = false
    var intro2Check: TimeAccumulator = .init(threshold: 1)
    
    private lazy var beginContactHandlerChain: ContactHandlerChain = {
        ContactHandlerChain(
            first: LanderGemContactHandler(
                scene: self,
                successor: BeginLanderDepotContactHandler(
                    cargo: cargo,
                    successor: LanderTerrainContactHandler(
                        scene: self,
                        successor: BeginLanderBoundsContactHandler(
                            scene: self,
                            successor: BombTerrainContactHandler(
                                successor: ShockwaveTerrainContactHandler(
                                    successor: LanderBombContactHandler(
                                        successor: nil
                        ))))))))
    }()
    
    private lazy var endContactHandlerChain: ContactHandlerChain = {
        ContactHandlerChain(
            first: EndLanderDepotContactHandler(
                scene: self,
                successor: EndLanderBoundsContactHandler(
                    scene: self, successor: nil
                )))
    }()
    
    class func load(levelNamed levelName: String) -> Self {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "LevelScene") as? Self else {
            print("Failed to load LevelScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        scene.levelName = levelName
        scene.setUpScene()
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        hud.layout()
    }
    
    private func setUpScene() {
        setupPhysics()
        setupCamera()
        setupLevel()
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = Const.PhysicsBody.gravity
        physicsWorld.contactDelegate = self
    }
    
    private func setupCamera() {
        let camera = SKCameraNode()
        self.camera = camera
        camera.position = .zero
        camera.zPosition = .greatestFiniteMagnitude
        camera.setScale(1)
        addChild(camera)
        cameraControl.camera = camera
        
        camera.addChild(hud)
        cargo.delegate = hud.gemCounter
        
    }
    
    private func setupLevel() {
        let levelLoader = LevelLoader(name: levelName)
        levelLoader.load(into: self)

        spawnLander()
        
        landerControl.lander = lander
        cameraControl.target = lander
        
        detectedGemCount = 0
        enumerateChildNodes(withName: "//\(Const.Node.Name.gem)", using: { _, _ in
            self.detectedGemCount += 1
        })
        
        // Bindings
        
        lander.telemetricDataDelegate = hud.speedGauge
        
        enumerateChildNodes(withName: "//\(Const.Node.Name.depot)", using: { node, _ in
            if let depot = node as? Depot {
                depot.delegate = self
                depot.sharedDepot = self.sharedDepot
            }
        })
        
        sharedDepot.delegate = hud.gemCounter
    }

    func start() {
        view?.isUserInteractionEnabled = false
        lander.physicsBody?.isDynamic = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view?.isUserInteractionEnabled = true
            self.presentIntro1()
        }
    }
    
    var updateGemDetector: TimeAccumulator = .init(threshold: 1)
    
    override func update(_ currentTime: TimeInterval) {
        time.update(current: currentTime)
        
        lander.update(time: time)
        landerControl.update()
        cameraControl.update(time: time)
        hud.missionTime.update(time: time)
        
        if updateGemDetector.update(time: time) {
            // TODO: Optimize and refactor
            var minDistance: CGFloat = .greatestFiniteMagnitude
            let landerPosition = convert(.zero, from: lander)
            enumerateChildNodes(withName: "//\(Const.Node.Name.gem)", using: { node, stop in
                let gemPosition = self.convert(.zero, from: node)
                let distance = CGFloat(gemPosition.distance(landerPosition))
                if distance < minDistance {
                    minDistance = distance
                }
            })
            
            if minDistance < Const.HUD.threshold(for: .immediate) {
                hud.gemDetector.show(.immediate)
            } else if minDistance < Const.HUD.threshold(for: .near) {
                hud.gemDetector.show(.near)
            } else if minDistance < Const.HUD.threshold(for: .far) {
                hud.gemDetector.show(.far)
            } else {
                hud.gemDetector.hide()
            }
        }
        
        if !didShowIntro2 {
            if didUseLeftThrusterAtLeastOnce && didUseRightThrusterAtLeastOnce {
                if intro2Check.update(time: time) {
                    presentIntro2()
                    didShowIntro2 = true
                }
            }
        }
    }
}

// MARK: - Touch

extension LevelScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else { return }
        for touch in touches {
            let location = touch.location(in: view)
            if location.x < view.bounds.width / 2.0 {
                landerControl.leftThruster?.fire()
            } else {
                landerControl.rightThruster?.fire()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else { return }
        for touch in touches {
            let location = touch.location(in: view)
            if location.x < view.bounds.width / 2.0 {
                landerControl.leftThruster?.release()
                didUseLeftThrusterAtLeastOnce = true
            } else {
                landerControl.rightThruster?.release()
                didUseRightThrusterAtLeastOnce = true
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = view else { return }
        for touch in touches {
            let location = touch.location(in: view)
            if location.x < view.bounds.width / 2.0 {
                landerControl.leftThruster?.release()
            } else {
                landerControl.rightThruster?.release()
            }
        }
    }
}

// MARK: Physics Contact

extension LevelScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        beginContactHandlerChain.handle(contact: contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        endContactHandlerChain.handle(contact: contact)
    }
}

// MARK: - Gameplay

extension LevelScene: DepotDelegate {
    func depotReadyToAcceptGems(_ depot: Depot) {
        let gems = cargo.unloadGems()
        depot.acceptGems(gems)
        
        let remainingGem = childNode(withName: "//\(Const.Node.Name.gem)")
        if remainingGem == nil {
            landerControl.enabled = false
            hud.missionTime.stop()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presentComplete()
            }
        }
    }
    
    func destroyLander() {
        let destroyPosition = convert(.zero, from: lander)
        landerControl.enabled = false
        FX.Explosion.play(in: self, at: destroyPosition)
        lander.removeFromParent()
        
        let droppedGems = cargo.unloadGems()
        for droppedGem in droppedGems {
            droppedGem.drop(in: self, at: destroyPosition)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentRestart()
        }
    }
    
    func destroyLanderOutOfBounds() {
        let destroyPosition = convert(.zero, from: lander)
        
        landerControl.enabled = false
        lander.physicsBody?.isDynamic = false
        lander.physicsBody?.velocity = .zero
        
        // TODO: Change warning text to "Connection lost"

        lander.run(.sequence([
            FX.shake(duration: 2),
            .removeFromParent(),
            .run { FX.Explosion.play(in: self, at: destroyPosition) },
            .run { self.presentRestart() },
            .run {
                if let dropPosition = self.lander.levelBoundsExitPosition {
                    self.dropGemsFromCargo(at: dropPosition)
                }
            }
        ]))
    }
    
    func spawnLander() {
        guard let spawn = childNode(withName: "//\(Const.Node.Name.spawn)") else { return }
        
        lander.position = convert(.zero, from: spawn)
        lander.physicsBody?.isDynamic = true
        addChild(lander)
        
        cameraControl.jump(to: lander) // without this the camera goes crazy
        
        landerControl.enabled = true
    }
    
    func dropGemsFromCargo(at position: CGPoint) {
        let droppedGems = cargo.unloadGems()
        for droppedGem in droppedGems {
            droppedGem.drop(in: self, at: position)
        }
    }
    
    func startOutOfBoundsCountDown() {
        run(
            .sequence([
                .wait(forDuration: Const.Node.Lander.outOfBoundsTimer),
                .run { self.destroyLanderOutOfBounds() }
            ]),
            withKey: "out_of_bounds_countdown"
        )
    }
    
    func cancelOutOfBoundsCountDown() {
        removeAction(forKey: "out_of_bounds_countdown")
    }
}

// MARK: - Presentation

// TODO: Refactor presentation

extension LevelScene {
    func presentRestart() {
        let restartViewController = RestartViewController.fromNib()
        restartViewController.modalPresentationStyle = .overCurrentContext
        restartViewController.modalTransitionStyle = .crossDissolve
        
        view?.window?.rootViewController?.present(restartViewController, animated: true)
        restartViewController.scene = self
    }
    
    func abortMission() {
        view?.isUserInteractionEnabled = false
        self.view?.window?.rootViewController?.dismiss(animated: true)
        
        UIView.animate(
            withDuration: 1,
            animations: { self.view?.alpha = 0 },
            completion: { _ in
                self.view?.window?.rootViewController = LevelSelectViewController.fromNib()
            }
        )
    }
    
    func presentMessages(_ messages: [Message], onDismiss: @escaping () -> Void = {}) {
        let viewController = MessageViewController.fromNib()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
        view?.window?.rootViewController?.present(viewController, animated: true)

        viewController.show(messages: messages)
        
        viewController.onDismiss = onDismiss
    }
    
    func presentComplete() {
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
            .init(text: "We've detected 10 Topsium shards on this site."),
            .init(text: "Once you've collected the shards, just return them to the depot near the probe and we'll be done here."),
            .init(text: "Alright, enough chatting. The probe is all yours now, good luck."),
        ]) {
            self.hud.layout()
            self.hud.missionTime.start()
            self.lander.physicsBody?.isDynamic = true
        }
    }
}
