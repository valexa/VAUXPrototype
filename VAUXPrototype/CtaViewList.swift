//
//  CtaViewList.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 15/08/2023.
//

import SwiftUI

struct CtaViewList: View {

    @ObservedObject private var backend = SimulatedBackendSingleton.sharedInstance

    @State private var legend = LegendView()

    var body: some View {
        Form {
            explaination
            VStack {
                Toggle("Simulate backend failure", isOn: $backend.willFail)
                    .padding(.bottom)
                Toggle("Simulate backend timeout", isOn: $backend.willTimeout)
            }
            .tint(.blue.mix(with: .white, amount: 0.5))
            .listRowBackground(Color.clear)
            Section(header: sectionLegend) {
                List {
                    ForEach(1..<6) { _ in
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            CtaView().scaleEffect(0.7)
                        } else {
                            CtaView()
                        }
                    }
                }
            }
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }

    var sectionLegend: some View {
        let label = ""
        let types: [LegendView.Types] = [.color, .style]
        return legend.makeLegend(label: label, types: types)
    }

    var explaination: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "heart")
                Text("- standard button with no state feedback (spammable)")
            }
            HStack {
                Image(systemName: "moon")
                Text("- button with slight blur on tap (non spammable)")
            }
            HStack {
                Image(systemName: "star")
                Text("- button with blur and scaling on tap (non spammable)")
            }
            HStack {
                Image(systemName: "sun.max")
                Text("- button with haptic feedback and progress bar (non spammable)")
            }
            HStack {
                Image(systemName: "flag")
                Text("- button with state animation (non spammable)")
            }
        }
        .font(.caption2)
        .listRowBackground(Color.clear)
    }
}

struct CtaViewList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CtaViewList()
        }
    }
}
