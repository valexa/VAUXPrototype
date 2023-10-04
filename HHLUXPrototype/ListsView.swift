//
//  ListsView.swift
//  HHLUXPrototype
//
//  Created by Vlad Alexa on 10/08/2023.
//

import SwiftUI

struct Tree<Value: Hashable>: Hashable {
    let value: Value
    var children: [Tree]?
}

struct ListsView: View {

    @State private var legend = LegendView()

    @ObservedObject private var backend = SimulatedBackendSingleton.sharedInstance

    @EnvironmentObject private var appSettings: AppSettings

    @ViewBuilder func makeLegend(label: String, types: [LegendView.Types] = [.style, .color]) -> some View {
        legend.makeLegend(label: "List with " + label, types: types)
    }

    let categories: [Tree<String>] = [
        Tree(
            value: "Yorkshire",
            children: [
                Tree(value: "Nowt"),
                Tree(value: "Reyt"),
                Tree(value: "Chuffin"),
                Tree(value: "Laff"),
                Tree(
                    value: "Ow",
                    children: [
                        Tree(value: "Ow much"),
                        Tree(value: "Ow come")
                    ]
                )
            ]
        ),
        Tree(
            value: "Northern",
            children: [
                Tree(value: "Canny"),
                Tree(value: "Bairn"),
                Tree(value: "Toon"),
                Tree(
                    value: "Howay",
                    children: [
                        Tree(value: "Howay man"),
                        Tree(value: "Howay with yous")
                    ]
                )
            ]
        )
    ]

    var body: some View {
        List {
            Section(header: makeLegend(label: "no sections")) {
                List {
                    Text("one")
                    Text("two")
                }
                .frame(height: 150)
                .listRowBackground(Color.clear)
            }
            Section(header: makeLegend(label: "no sections plain")) {
                List {
                    Text("one")
                    Text("two")
                }
                .listStyle(.plain)
                .frame(height: 150)
                .listRowBackground(Color.clear)
            }
            Section(header: makeLegend(label: "sections")) {
                List {
                    Section("section one") {
                        Text("one")
                    }
                    Section("section two") {
                        Text("two")
                    }
                }
                .listStyle(.insetGrouped)
                .frame(height: 200)
                .listRowBackground(Color.clear)
            }
            Section(header: makeLegend(label: "plain sections")) {
                List {
                    Section("section one") {
                        Text("one")
                    }
                    Section("section two") {
                        Text("two")
                    }
                }
                .listStyle(.plain)
                .frame(height: 200)
                .listRowBackground(Color.clear)
            }
            Section(header: makeLegend(label: "inset sections")) {
                List {
                    Section("section one") {
                        Text("one")
                    }
                    Section("section two") {
                        Text("two")
                    }
                }
                .listStyle(.inset)
                .frame(height: 200)
                .listRowBackground(Color.clear)
            }
            Section(header: makeLegend(label: "outline group")) {
                List {
                    ForEach(categories, id: \.self) { section in
                        Section(header: Text(section.value)) {
                            OutlineGroup(
                                section.children ?? [],
                                id: \.value,
                                children: \.children
                            ) { tree in
                                Text(tree.value)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .frame(height: 400)
            }
            Section(header: makeLegend(label: "split navigation")) {
                split
            }
        }
        .ifModifier(appSettings.defaults.orangeTint) { view in
            view.tint(.orange)
        }
    }

    var split: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    Text("content one")
                } label: {
                    Label("one", systemImage: "1.circle")
                }
                NavigationLink {
                    Text("content two")
                } label: {
                    Label("two", systemImage: "2.circle")
                }
            }
        } detail: {
            ContentUnavailableView("Use sidebar navigation", systemImage: "sidebar.left")
        }
    }

}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
            .environmentObject(AppSettings())
    }
}
