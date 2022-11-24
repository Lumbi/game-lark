//
//  SceneDelegate.swift
//  Lark iOS
//
//  Created by Gabriel Lumbi on 2022-11-24.
//

import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = LevelSelectViewController.fromNib()
        self.window = window
        window.makeKeyAndVisible()
    }
}
