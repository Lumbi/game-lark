//
//  GameScene.swift
//  Lark Shared
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import SpriteKit
import SKTiled

class LevelScene: SKScene {
    var levelName: LevelName { fatalError("Must override") }

    private(set) var time: Time = .init()

    let lander: Lander = .init()
    let cargo: Cargo = .init()
    let hud: HUD = .init()
    let landerControl: LanderControl = .init()
    let cameraControl: CameraControl = .init()
    let sharedDepot: SharedDepot = .init()

    private(set) var detectedGemCount: Int = 0
    private let progressService: ProgressService = .init()
    
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

    override init() {
        super.init(size: .init(width: 1000, height: 1000))
        scaleMode = .aspectFill
        setUpScene()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let levelLoader = LevelLoader(name: levelName.rawValue)
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
        didStart()
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
    }

    // MARK: - Gameplay callbacks

    func didStart() {}

    func didComplete() {
        progressService.complete(levelName: .w1_l1)
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
            } else {
                landerControl.rightThruster?.release()
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
                self.didComplete()
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
}
