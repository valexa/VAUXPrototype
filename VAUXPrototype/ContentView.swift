//
//  ContentView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 10/08/2023.
//

import SwiftUI
import TipKit

struct ContentView: View {

//    @SceneStorage("ContentView.selectedTab")

    @UIApplicationDelegateAdaptor(HHLAppDelegate.self) var delegate

    @EnvironmentObject private var appSettings: AppSettings

    @ObservedObject var model: PrototypesList

    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    @State private var searchText = ""

    @ObservedObject private var backend = SimulatedBackendSingleton.sharedInstance

    @Environment(\.openWindow) private var openWindow

    @Environment(\.scenePhase) var scenePhase

    @State private var shake: Bool = false

    @State private var centeredPrototype: Prototype?

    var multiTip = MultitaskingTip()

    var settingsTip = SettingsTip()

    var body: some View {
        Group {
            if centeredPrototype != nil {
                centeredPrototype?.view
            } else {
                splitView
            }
        }
        .ifModifier(appSettings.defaults.lightMode) { view in
            view.colorScheme(.light)
        }
        .onAppear {
            setAppearance()
        }
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                openScene()
            }
        }
        .onContinueUserActivity(Prototype.buttons.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.selectors.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.switches.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.pickers.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.input.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.popups.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.tips.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.lists.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.menus.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.loading.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.states.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
        .onContinueUserActivity(Prototype.symbols.rawValue) { activity in
            centeredPrototype = Prototype(activity: activity)
        }
//        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
    }

    var splitView: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            VStack {
                sidebarList
                Spacer()
                footer
                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("VAUXPrototype")
            .navigationSplitViewStyle(.balanced)
            .navigationBarTitleDisplayMode(.inline)
        } detail: {
            shakeButton
                .symbolEffect(.bounce.byLayer, value: shake)
        }
    }

    @MainActor
    func openScene() {
        if let shortcut = delegate.sideLoad {
            openWindow(value: shortcut)
            delegate.sideLoad = nil
        }
    }

    func setAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .ultraLight)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 34, weight: .ultraLight)]
    }

    var shakeButton: some View {
        Button(action: {
            withAnimation {
                shake.toggle()
            }
        }) {
            Image(systemName: "square.stack.3d.forward.dottedline.fill", variableValue: shake ? 0.5 : 0.7)
        }
        .modifier(ShakeEffect(shakes: shake ? 2 : 0))
    }

    func determineGearIcon() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        if hour >= 0 && hour < 12 {
            return "gearshape"
        } else if hour >= 12 && hour < 17 {
            return "gear"
        } else {
            return "gearshape.2"
        }
    }

    var footer: some View {
        VStack {
            TipView(settingsTip, arrowEdge: .bottom)
            settingsMenu
                .font(.callout)
                .padding()
            Text("Copyright 2023 hedgehog lab")
                .font(.caption)
        }
        .foregroundColor(.black.mix(with: .white, amount: 0.7))
        .shadow(color: .white, radius: 0.1, x: 0, y: 1)
    }

    var settingsMenu: some View {
        Menu(content: {
            SettingsView()
        }, label: {
            Label("Settings", systemImage: determineGearIcon())
        })
    }

    var sidebarList: some View {
        List {
            Section {
                ForEach(model[category: .primary]) {
                    ProtoypeLink(type: $0)
                }
                if UIDevice.current.userInterfaceIdiom == .pad {
                    TipView(multiTip, arrowEdge: .top)
                }
            }
            Section {
                ForEach(model[category: .secondary]) {
                    ProtoypeLink(type: $0)
                }
            }
            Section {
                ForEach(model[category: .extra]) {
                    ProtoypeLink(type: $0)
                }
            }
            if UIDevice.current.userInterfaceIdiom == .pad {
                Section {
                    ForEach(model[category: .ipad]) {
                        ProtoypeLink(type: $0)
                    }
                }
            }
            if UIDevice.current.userInterfaceIdiom == .phone {
                Section {
                    ProtoypeLink(type: .haptics)
                }
            }
        }
    }

}

extension ContentView {
    struct MultitaskingTip: Tip {
        var title: Text {
            Text("Multitasking")
        }
        var message: Text? {
            Text("Long press on any categories for the multitasking and shortcut menu.")
        }
        var asset: Image? {
            Image(systemName: "light.panel")
        }
    }
    struct SettingsTip: Tip {
        var title: Text {
            Text("Check out the settings")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = PrototypesList()
        Group {
            ContentView(model: model)
                .environment(\.colorScheme, .light)
                .previewDisplayName("Default")

            ContentView(model: model)
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")

        }
        .environmentObject(AppSettings())
    }
}
