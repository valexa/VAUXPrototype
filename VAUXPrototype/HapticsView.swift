//
//  HapticsView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 14/08/2023.
//

import SwiftUI
import CoreHaptics

#if os(iOS)

struct HapticsView: View {

    @State private var engine: CHHapticEngine?

    var body: some View {
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            list
        } else {
            Text("Haptics not available on this device")
        }
    }

    var list: some View {
        List {
            Section {
                Button("Soft impact") {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                Button("Rigid impact") {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
            }
            Section {
                Button("Light impact") {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                Button("Medium impact") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                Button("Heavy impact") {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
            }
            Section {
                Button("Success notification") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
                Button("Warning notification") {
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                }
                Button("Error notification") {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
            Section("custom") {
                Button("Boing") {
                    playCustom(filename: "Boing")
                }
                Button("Heartbeat") {
                    playCustom(filename: "Heartbeat")
                }
                Button("Inflate") {
                    playCustom(filename: "Inflate")
                }
                Button("Rumble") {
                    playCustom(filename: "Rumble")
                }
                Button("Oscillate") {
                    playCustom(filename: "Oscillate")
                }
            }
            Link(" HIG link ⤴", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines/playing-haptics")!)
        }
    }

    func playCustom(filename: String) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        guard let path = Bundle.main.path(forResource: filename, ofType: "ahap") else {
            return
        }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            try engine?.playPattern(from: URL(fileURLWithPath: path))
        } catch {
            print("There was an error \(error.localizedDescription)")
        }
    }

}

struct HapticsView_Previews: PreviewProvider {
    static var previews: some View {
        HapticsView()
    }
}

#endif
