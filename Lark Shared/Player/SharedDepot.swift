//
//  SharedDepot.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-16.
//

import Foundation

protocol SharedDepotDelegate: AnyObject {
    func sharedDepotDidUpdate(_ sharedDepot: SharedDepot)
}

class SharedDepot {
    weak var delegate: SharedDepotDelegate? = nil {
        didSet {
            delegate?.sharedDepotDidUpdate(self)
        }
    }
    
    private(set) var gems: [Gem] = []
    
    func deposit(_ gems: [Gem]) {
        self.gems.append(contentsOf: gems)
        delegate?.sharedDepotDidUpdate(self)
    }
}
