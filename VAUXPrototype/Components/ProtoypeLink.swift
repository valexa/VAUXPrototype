//
//  ProtoypeLink.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 22/08/2023.
//

import SwiftUI

struct ProtoypeLink: View {

    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    @Environment(\.openWindow) private var openWindow

    @State var type: Prototype

    @State var persistent = false

    var body: some View {
        NavigationLink {
            type.view
        } label: {
            Label(type.title, systemImage: type.iconName)
        }
        .ifModifier(supportsMultipleWindows) { view in
            view.contextMenu {
                Label("Multitasking", systemImage: "rectangle.badge.plus")
                Button {
                    openWindow(value: type)
                } label: {
                    Label("Open in New Window", systemImage: "rectangle.righthalf.inset.filled")
                }
                Button {
                    openCenter(value: type)
                } label: {
                    Label("Open in Center Window", systemImage: "rectangle.center.inset.filled")
                }
                Label("Shortcuts", systemImage: "apps.iphone")
                Toggle("App icon shortcut", isOn: $persistent)
                    .onChange(of: persistent) { _ in
                        changeSetting()
                    }
            }
        }
        .onAppear {
            readSetting()
        }
    }

    func readSetting() {
        let defaults = UserDefaults.standard
        guard let list = defaults.value(forKey: "shortcutItems") as? [String] else { return }
        if list.contains(type.rawValue) {
            persistent = true
        }
    }

    func changeSetting() {
        let defaults = UserDefaults.standard
        var list = defaults.value(forKey: "shortcutItems") as? [String] ?? [String]()
        if persistent {
            if !list.contains(type.rawValue) {
                list.append(type.rawValue)
            }
        } else {
            list = list.filter {
                $0 != type.rawValue
            }
        }
        if list.count > 4 {
            list.removeFirst()
        }
        defaults.setValue(list, forKey: "shortcutItems")
    }

    func openCenter(value: Prototype) {
        let options = UIWindowScene.ActivationRequestOptions()
        options.placement = UIWindowSceneProminentPlacement()
        let userActivity = NSUserActivity(activityType: value.rawValue)
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: options) { error in
            print(error)
        }
    }

}

struct ProtoypeLink_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ProtoypeLink(type: .buttons)
            ProtoypeLink(type: .input)
            ProtoypeLink(type: .haptics)
        }
    }
}

