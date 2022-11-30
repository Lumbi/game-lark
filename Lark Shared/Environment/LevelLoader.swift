//
//  LevelLoader.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-08.
//

import Foundation
import SpriteKit
import SKTiled

/*
 Loads level from Tiled JSON
 */

class LevelLoader {   
    private let name: String
    private var tilemap: SKTilemap?
    
    init(name: String) {
        self.name = name
    }
    
    func load(into scene: SKScene) {
        tilemap = SKTilemap.load(tmxFile: "Tilemaps/\(name)")
        if let tilemap = tilemap {
            scene.addChild(tilemap)
            setupBounds()
            addTileCollisionBoxes()
            populateGems()
            populateDepots()
            populateBombs()
        }
    }
    
    func setupBounds() {
        if let bounds = tilemap?.getObjects(named: Const.Node.Name.innerBounds).first {
            let collisionBox = SKNode()
            collisionBox.physicsBody = .init(rectangleOf: bounds.size)
            collisionBox.physicsBody?.isDynamic = false
            collisionBox.physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.innerBounds
            collisionBox.physicsBody?.collisionBitMask = 0
            collisionBox.physicsBody?.contactTestBitMask = Const.PhysicsBody.Bitmask.lander
            collisionBox.position = .init(x: bounds.size.halfWidth, y: -bounds.size.halfHeight)
            collisionBox.addChild(SKShapeNode(rectOf: bounds.size)) // TODO: Remove
            bounds.addChild(collisionBox)
        }
        
        if let bounds = tilemap?.getObjects(named: Const.Node.Name.outerBounds).first {
            let collisionBox = SKNode()
            collisionBox.physicsBody = .init(rectangleOf: bounds.size)
            collisionBox.physicsBody?.isDynamic = false
            collisionBox.physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.outerBounds
            collisionBox.physicsBody?.collisionBitMask = 0
            collisionBox.physicsBody?.contactTestBitMask = Const.PhysicsBody.Bitmask.lander
            collisionBox.position = .init(x: bounds.size.halfWidth, y: -bounds.size.halfHeight)
            collisionBox.addChild(SKShapeNode(rectOf: bounds.size)) // TODO: Remove
            bounds.addChild(collisionBox)
        }
    }
    
    private func populateGems() {
        guard let tilemap = tilemap, let scene = tilemap.scene else { return }
        for placeholder in tilemap.getObjects(named: Const.Node.Name.gem) {
            if placeholder.visible {
                let gem = Gem()
                gem.position = scene.convert(.zero, from: placeholder)
                scene.addChild(gem)
            }
            placeholder.removeFromParent()
        }
    }
    
    private func populateDepots() {
        guard let tilemap = tilemap else { return }
        for placeholder in tilemap.getObjects(named: Const.Node.Name.depot) {
            let depot = Depot()
            depot.position = placeholder.position
            placeholder.parent?.addChild(depot)
            placeholder.removeFromParent()
        }
    }
    
    private func populateBombs() {
        guard let tilemap = tilemap, let scene = tilemap.scene else { return }
        for placeholder in tilemap.getObjects(named: Const.Node.Name.bomb) {
            if placeholder.visible {
                let bomb = Bomb()
                bomb.position = scene.convert(.zero, from: placeholder)
                scene.addChild(bomb)
            }
            placeholder.removeFromParent()
        }
    }
    
    private func addTileCollisionBoxes() {
        guard let tilemap = tilemap else { return }
        for tileLayer in tilemap.tileLayers() {
            guard tileLayer.getValue(forProperty: Const.Layer.Property.collision) != nil else { continue }
            for tile in tileLayer.getTiles() {
                let collisionBox = SKNode()
                collisionBox.physicsBody = SKPhysicsBody(rectangleOf: tile.tileSize)
                collisionBox.physicsBody?.affectedByGravity = false
                collisionBox.physicsBody?.isDynamic = false
                collisionBox.physicsBody?.allowsRotation = false
                collisionBox.physicsBody?.categoryBitMask = Const.PhysicsBody.Bitmask.terrain
                collisionBox.physicsBody?.collisionBitMask = Const.PhysicsBody.Bitmask.all
                tile.addChild(collisionBox)
            }
        }
    }
}
