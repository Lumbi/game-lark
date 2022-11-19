//
//  UIViewController+Ext.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-13.
//

import Foundation
import UIKit

extension UIViewController {
    static func fromNib() -> Self {
//        func instantiateFromNib<T: UIViewController>() -> T {
//            return T.init(nibName: String(describing: T.self), bundle: nil)
//        }
        
        return Self.init(nibName: String(describing: self), bundle: nil)

//        return instantiateFromNib()
    }
}
