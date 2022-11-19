//
//  Localization.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-13.
//

import Foundation

func localized(_ key: String) -> String {
    NSLocalizedString(key, comment: key)
}
