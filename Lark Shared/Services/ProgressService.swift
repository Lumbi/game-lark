//
//  ProgressService.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-12-03.
//

import Foundation

enum LevelName: String, CaseIterable {
    case sandbox = "sandbox"
    case w1_l1 = "level-1-1"
    case w1_l2 = "level-1-2"
    case w1_l3 = "level-1-3"
}

enum LevelProgress: String {
    case locked = "locked"
    case unlocked = "unlocked"
    case completed = "completed"
}

class ProgressService {
    private let userDefaults: UserDefaults = .standard

    func progress(for levelName: LevelName) -> LevelProgress {
        if let rawValue = userDefaults.string(forKey: qualifiedKey(for: levelName.rawValue)),
           let progress = LevelProgress(rawValue: rawValue)
        {
            return progress
        } else {
            if levelName == LevelName.w1_l1 { // Special case for level
                return .unlocked
            } else {
                return .locked
            }
        }
    }

    func complete(levelName: LevelName) {
        userDefaults.set(LevelProgress.completed.rawValue, forKey: qualifiedKey(for: levelName.rawValue))

        // TODO: Refactor to use level graph
        switch levelName {
        case .sandbox:
            // Nothing
            break
        case .w1_l1:
            unlock(levelName: .w1_l2)
        case .w1_l2:
            unlock(levelName: .w1_l3)
        case .w1_l3:
            // all clear
            break
        }
    }

    func reset() {
        for levelName in LevelName.allCases {
            userDefaults.set(nil, forKey: qualifiedKey(for: levelName.rawValue))
        }
    }

    private func unlock(levelName: LevelName) {
        if case .locked = progress(for: levelName) {
            userDefaults.set(LevelProgress.unlocked.rawValue, forKey: qualifiedKey(for: levelName.rawValue))
        }
    }

    private func qualifiedKey(for key: String) -> String {
        "\(Bundle.main.bundleIdentifier!).\(Self.self).\(key)"
    }
}
