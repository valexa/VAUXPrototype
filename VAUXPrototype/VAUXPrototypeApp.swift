//
//  VAUXPrototypeApp.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 10/08/2023.
//

import SwiftUI

@main
struct VAUXPrototypeApp: App {

    private var dataModel = PrototypesList()
    @StateObject private var appSettings = AppSettings()
    @UIApplicationDelegateAdaptor var delegate: HHLAppDelegate

    var body: some Scene {
        WindowGroup("Prototypes with Menu") {
            ContentView(model: dataModel)
                .environmentObject(appSettings)
                .task(priority: .medium) {
                    await appSettings.load()
                }
        }
        .commands { SidebarCommands() }
        .handlesExternalEvents(matching: ["hhlink://menu"])

//        WindowGroup("Prototypes Details (center)") {
//            ProtoWindow(model: dataModel, proto: .constant(delegate.centerLoad))
//                .environmentObject(appSettings)
//        }
//        .handlesExternalEvents(matching: ["hhlink://center"])

        WindowGroup("Prototypes Details (side)", for: Prototype.self) { $proto in
            ProtoWindow(model: dataModel, proto: $proto)
                .environmentObject(appSettings)
        }
        .handlesExternalEvents(matching: ["hhlink://side"])
    }

}
