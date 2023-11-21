//
//  HHLSceneDelegate.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 21/08/2023.
//

import UIKit
import SwiftUI

class HHLSceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {

    @UIApplicationDelegateAdaptor(HHLAppDelegate.self) var delegate

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        makeShortcutItems()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        makeShortcutItems()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let activity = connectionOptions.userActivities.first {
            if let type = Prototype(activity: activity) {
                print("Center new screen: " + type.rawValue)
            }
        }
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handled = handleShortCutItem(shortcutItem)
        completionHandler(handled)
    }

    func handleShortCutItem(_ item: UIApplicationShortcutItem) -> Bool {
        if let type = Prototype(shortcut: item) {
            delegate.sideLoad = type
            print("Split new screen: " + type.rawValue)
            return true
        }
        return false
    }

    func makeShortcutItems() {
        let defaults = UserDefaults.standard
        guard let list = defaults.value(forKey: "shortcutItems") as? [String] else { return }
        var items = [Prototype]()
        for item in list {
            if let proto = Prototype(rawValue: item) {
                items.append(proto)
            }
        }
        UIApplication.shared.shortcutItems = items.map { item -> UIApplicationShortcutItem in
            return item.makeShortcut()
        }
    }

}
