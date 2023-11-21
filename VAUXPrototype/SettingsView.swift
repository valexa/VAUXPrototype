//
//  SettingsView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 15/08/2023.
//

import SwiftUI
import UIKit

struct SettingsView: View {

    @ObservedObject private var backend = SimulatedBackendSingleton.sharedInstance

    @EnvironmentObject private var appSettings: AppSettings

    @State private var shake: Bool = false

    var body: some View {
        Group {
            Toggle("Orange tint", isOn: $appSettings.defaults.orangeTint)
            Toggle("Force light mode", isOn: $appSettings.defaults.lightMode)
            Toggle("Force backend failure", isOn: $backend.willFail)
            Toggle("Force backend timeout", isOn: $backend.willTimeout)
            stepper
            Text("SwiftUI \(Bundle.main.swiftuiVersionNumber)")
                .font(.footnote)
            label
                .symbolEffect(.bounce.down, value: backend.delayValue)
        }
        .tint(.blue.mix(with: .white, amount: 0.5))
    }

    var stepper: some View {
        Stepper {
            Text("Backend delay: \(Int(backend.delayValue)) sec")
        } onIncrement: {
            backend.delayValue += 1
        } onDecrement: {
            if backend.delayValue > 1 {
                backend.delayValue -= 1
            } else {
                withAnimation {
                    shake.toggle()
                }
            }
        }
        .modifier(ShakeEffect(shakes: shake ? 2 : 0))
    }

    var label: some View {
        let version = Bundle.main.releaseVersionNumber
        let build = Bundle.main.buildVersionNumber
        return Label("v\(version) build \(build)", systemImage: "app.dashed")
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SettingsView()

            Menu(content: {
                SettingsView()
            }, label: {
                Label("Settings", systemImage: "gear")
            })
        }
        .environmentObject(AppSettings())
    }
}

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -5 * sin(position * 2 * .pi), y: 0))
    }

    init(shakes: Int) {
        position = CGFloat(shakes)
    }

    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}
