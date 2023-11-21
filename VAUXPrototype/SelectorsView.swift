//
//  SelectorsView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 10/08/2023.
//

import SwiftUI

struct SelectorsView: View {

    @State private var selector = 0
    @State private var isShowingLabels = true
    @State private var isColored = false

    @State private var legend = LegendView()

    @ObservedObject private var backend = SimulatedBackendSingleton.sharedInstance

    @EnvironmentObject private var appSettings: AppSettings

    var wheelLegend: some View {
        let label = "Wheel selector"
        let types: [LegendView.Types] = [.style, .scale]
        return legend.makeLegend(label: label, types: types)
    }

    var inlineLegend: some View {
        let label = "Inline selector"
        let types: [LegendView.Types] = [.style, .scale, .label]
        return legend.makeLegend(label: label, types: types)
    }

    var segmentedLegend: some View {
        let label = "Segmented selector"
        let types: [LegendView.Types] = [.color, .style, .scale]
        return legend.makeLegend(label: label, types: types)
    }

    var navigationLegend: some View {
        let label = "Navigation selector"
        let types: [LegendView.Types] = [.style, .scale]
        return legend.makeLegend(label: label, types: types)
    }

    var menuLegend: some View {
        let label = "Menu selector"
        let types: [LegendView.Types] = [.style, .scale, .label]
        return legend.makeLegend(label: label, types: types)
    }

    var body: some View {
        VStack {
            settings
            .padding(.horizontal)
            form
            .ifModifier(!isShowingLabels) { view in
                view.labelsHidden()
            }
        }
        .ifModifier(appSettings.defaults.orangeTint) { view in
            view.tint(.orange)
        }
        .background(Color(UIColor.secondarySystemBackground))
    }

    var form: some View {
        List {
            Section(header: inlineLegend) {
                inline
                    .ifModifier(isColored) { view in
                        view.colorMultiply(.orange)
                    }
            }
            Section(header: segmentedLegend) {
                segmented
                    .ifModifier(isColored) { view in
                        view.colorMultiply(.orange)
                    }
            }
            Section(header: wheelLegend) {
                wheel
                    .ifModifier(isColored) { view in
                        view.colorMultiply(.orange)
                    }
                    .frame(height: 100)

            }
            Section(header: menuLegend) {
                menu
                    .ifModifier(isColored) { view in
                        view.colorMultiply(.orange)
                    }
            }
            Section(header: navigationLegend) {
                navigation
                    .ifModifier(isColored) { view in
                        view.colorMultiply(.orange)
                    }
            }
        }
    }

    var settings: some View {
        VStack {
            VStack {
                Toggle("Show labels", isOn: $isShowingLabels)
                Toggle("Orange tint", isOn: $appSettings.defaults.orangeTint)
                Toggle("Orange overlay", isOn: $isColored)

            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .tint(.blue.mix(with: .white, amount: 0.5))
            .padding()
            Divider()
        }
    }

    var inline: some View {
        Picker(selection: $selector, label: Text("Label")) {
            Text("Thin").tag(0)
            Text("Regular").tag(1)
            Text("Bold").tag(2)
        }
        .pickerStyle(.inline)
    }

    var wheel: some View {
        Picker(selection: $selector, label: Text("Label")) {
            Text("Thin").tag(0)
            Text("Regular").tag(1)
            Text("Bold").tag(2)
        }
        .pickerStyle(.wheel)
    }

    var segmented: some View {
        Picker(selection: $selector, label: Text("Label")) {
            Text("Thin").tag(0)
            Text("Regular").tag(1)
            Text("Bold").tag(2)
        }
        .pickerStyle(.segmented)
    }

    var navigation: some View {
        Picker(selection: $selector, label: Text("Label (always shown)")) {
            Text("Thin").tag(0)
            Text("Regular").tag(1)
            Text("Bold").tag(2)
        }
        .pickerStyle(.navigationLink)
    }

    var menu: some View {
        Picker(selection: $selector, label: Text("Label")) {
            Text("Thin").tag(0)
            Text("Regular").tag(1)
            Text("Bold").tag(2)
        }
        .pickerStyle(.menu)
    }

}

struct SelectorsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorsView()
            .environmentObject(AppSettings())
    }
}
