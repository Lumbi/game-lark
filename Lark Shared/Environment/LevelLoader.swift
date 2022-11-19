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
            addTileCollisionBoxes()
            populateGems()
            populateDepots()
        }
    }
    
    func spawnLander() -> Lander {
        let lander = Lander()
        if let spawn = tilemap?.getObjects(named: Const.Node.Name.spawn).first {
            spawn.name = Const.Node.Name.spawn
            lander.position = spawn.position
            spawn.layer.addChild(lander)
        } else {
            tilemap?.scene?.addChild(lander)
        }
        return lander
    }
    
    private func populateGems() {
        guard let tilemap = tilemap, let scene = tilemap.scene else { return }
        for placeholder in tilemap.getObjects(named: Const.Node.Name.gem) {
            let gem = Gem()
            gem.position = scene.convert(.zero, from: placeholder)
            placeholder.removeFromParent()
            scene.addChild(gem)
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
