//
//  GameScene.swift
//  Lark Shared
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import SpriteKit
import SKTiled

class GameScene: SKScene {
    var lander: Lander? = nil
    let cargo: Cargo = .init()
    let hud: HUD = .init()
    let landerControl: LanderControl = .init()
    let cameraControl: CameraControl = .init()
    let sharedDepot: SharedDepot = .init()
    private(set) var detectedGemCount: Int = 0
    
    private var time: Time = .init()
    
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
                            successor: nil
                        )))))
    }()
    
    private lazy var endContactHandlerChain: ContactHandlerChain = {
        ContactHandlerChain(
            first: EndLanderDepotContactHandler(
                successor: EndLanderBoundsContactHandler(
                    scene: self, successor: nil
                )))
    }()
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
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
        hud.layout()
    }
    
    private func setupLevel() {
        let levelLoader = LevelLoader(name: "TestLevel")
        levelLoader.load(into: self)
        lander = levelLoader.spawnLander()
        landerControl.lander = lander
        cameraControl.target = lander
        
        detectedGemCount = 0
        scene?.enumerateChildNodes(withName: "//\(Const.Node.Name.gem)", using: { _, _ in
            self.detectedGemCount += 1
        })
        
        // Bindings
        
        lander?.telemetricDataDelegate = hud.speedGauge
        
        scene?.enumerateChildNodes(withName: "//\(Const.Node.Name.depot)", using: { node, _ in
            if let depot = node as? Depot {
                depot.delegate = self
                depot.sharedDepot = self.sharedDepot
            }
        })
        
        sharedDepot.delegate = hud.gemCounter
    }
    
    var updateGemDetector: TimeAccumulator = .init(threshold: 1)
    
    override func update(_ currentTime: TimeInterval) {
        time.update(current: currentTime)
        
        lander?.update(time: time)
        landerControl.update()
        cameraControl.update(time: time)
        
        if updateGemDetector.update(time: time) {
            if let lander = lander {
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
    }
}

extension GameScene {
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
        
        
        // TODO: REmove, test
        presentMessage()
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

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        beginContactHandlerChain.handle(contact: contact)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        endContactHandlerChain.handle(contact: contact)
    }
}

extension GameScene: DepotDelegate {
    func depotReadyToAcceptGems(_ depot: Depot) {
        let gems = cargo.unloadGems()
        depot.acceptGems(gems)
        
        let remainingGem = childNode(withName: "//\(Const.Node.Name.gem)")
        if remainingGem == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presentComplete()
            }
        }
    }
}

extension GameScene {
    func destroyLander() {
        guard let lander = lander else { return }
        
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
        guard let lander = lander else { return }
        
        let destroyPosition = convert(.zero, from: lander)
        
        landerControl.enabled = false
        lander.physicsBody?.isDynamic = false
        lander.physicsBody?.velocity = .zero
        
        // Change warning text to "Connection lost"
        // TODO: What to do with gems
        
        print("initiating self-destruct...")
        
        lander.run(.sequence([
            FX.shake(duration: 2),
            .removeFromParent(),
            .run { FX.Explosion.play(in: self, at: destroyPosition) },
            .run { self.presentRestart() }
        ]))
    }
    
    func redeployLanderToLastCheckpoint() {
        let spawn = childNode(withName: "//\(Const.Node.Name.spawn)")
        
        guard
            let lander = lander,
            let spawn = spawn,
            let parent = spawn.parent
        else { return }
        
        lander.position = spawn.position
        lander.physicsBody?.isDynamic = true
        parent.addChild(lander)
        
        cameraControl.jump(to: lander) // without this the camera goes crazy
        
        landerControl.enabled = true
    }
    
    func dropGemsFromCargo() {
        guard let lander = lander else { return }
        let exitPosition = convert(.zero, from: lander)
        let droppedGems = cargo.unloadGems()
        for droppedGem in droppedGems {
            droppedGem.drop(in: self, at: exitPosition)
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

extension GameScene {
    func presentRestart() {
        let restartViewController = RestartViewController.fromNib()
        restartViewController.modalPresentationStyle = .overCurrentContext
        restartViewController.modalTransitionStyle = .crossDissolve
        
        view?.window?.rootViewController?.present(restartViewController, animated: true)
        restartViewController.scene = self
    }
    
    func presentComplete() {
        let viewController = MissionCompleteViewController.fromNib()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
        view?.window?.rootViewController?.present(viewController, animated: true)
    }
    
    func presentMessage() {
        let viewController = MessageViewController.fromNib()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        
        view?.window?.rootViewController?.present(viewController, animated: true)
        
        viewController.show(message: .init(text: "Mario is a character created by Japanese video game designer Shigeru Miyamoto. He is the title character of the Mario franchise and the mascot of Japanese video game company Nintendo."))
    }
}
