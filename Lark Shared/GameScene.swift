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
    private var time: Time = .init()
    
    private lazy var beginContactHandlerChain: ContactHandlerChain = {
        ContactHandlerChain(
            first: LanderGemContactHandler(
                cargo: cargo,
                successor: BeginLanderDepotContactHandler(
                    cargo: cargo,
                    successor: LanderTerrainContactHandler(
                        scene: self,
                        successor: nil
                    ))))
    }()

    private lazy var endContactHandlerChain: ContactHandlerChain = {
        ContactHandlerChain(first: EndLanderDepotContactHandler(
            successor: nil
        ))
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
        physicsWorld.gravity = .init(dx: 0, dy: -1)
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
        lander?.telemetricDataDelegate = hud.speedGauge
        
        // Bind depot events
        scene?.enumerateChildNodes(withName: "//\(Const.Node.Name.depot)", using: { node, _ in
            if let depot = node as? Depot {
                depot.delegate = self
            }
        })
    }
    
    var updateGemDetector: TimeAccumulator = .init(threshold: 1)
    
    override func update(_ currentTime: TimeInterval) {
        time.update(current: currentTime)
        landerControl.update()
        
        if let lander = lander {
            lander.update(time: time)
            cameraControl.follow(target: lander, duration: 1.0, time: time)
        }
        
        if updateGemDetector.update(time: time) {
            if let lander = lander {
                // TODO: Optimize
                var minDistance: CGFloat = .greatestFiniteMagnitude
                let landerPosition = convert(.zero, from: lander)
                enumerateChildNodes(withName: "//\(Const.Node.Name.gem)", using: { node, stop in
                    let gemPosition = self.convert(.zero, from: node)
                    let distance = CGFloat(gemPosition.distance(landerPosition))
                    if distance < minDistance {
                        minDistance = distance
                    }
                })
                
                print("minDistance", minDistance)

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
                landerControl.leftThruster?.enable()
            } else {
                landerControl.rightThruster?.enable()
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
    }
}

extension GameScene {
    func destroyLander() {
        landerControl.enabled = false
        if let scene = scene, let lander = lander {
            FX.Explosion.play(in: scene, at: lander.convert(.zero, to: scene))
            lander.removeFromParent()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let restartViewController = RestartViewController.fromNib()
            restartViewController.modalPresentationStyle = .overCurrentContext
            restartViewController.modalTransitionStyle = .crossDissolve
            restartViewController.preferredContentSize = .init(width: 300, height: 200)
            
            self.view?.window?.rootViewController?.present(restartViewController, animated: true)
            restartViewController.scene = self
        }
    }

    func redeployLanderToLastCheckpoint() {
        let spawn = childNode(withName: "//\(Const.Node.Name.spawn)")
        
        guard
            let lander = lander,
            let spawn = spawn,
            let parent = spawn.parent
        else { return }

        lander.position = spawn.position
        parent.addChild(lander)

        cameraControl.jump(to: lander) // without this the camera goes crazy
        
        landerControl.enabled = true
    }
}
