//
//  Cargo.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-09.
//

import Foundation

class Cargo {
    var gemCount: Int { gems.count }
    private var gems: [Gem] = []
    
    weak var delegate: CargoDelegate? = nil {
        didSet {
            delegate?.cargoDidUpdate(self)
        }
    }
    
    func pickUp(gem: Gem) {
        gem.removeFromParent()
        gems.append(gem)
        
        delegate?.cargoDidUpdate(self)
    }
    
    func unloadGems() -> [Gem] {
        let unloadedGems = gems
        gems.removeAll()
        delegate?.cargoDidUpdate(self)
        return unloadedGems
    }
}

protocol CargoDelegate: AnyObject {
    func cargoDidUpdate(_ cargo: Cargo)
}
