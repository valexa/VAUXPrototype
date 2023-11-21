//
//  SymbolsView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 10/08/2023.
//

import SwiftUI

struct SymbolsView: View {

    @State private var weight: Font.Weight = .regular
    @State private var filled = false
    @State private var multicolor = true
    @State private var searchText = ""

    private static var icons: [String] = {
        guard let path = Bundle.main.path(forResource: "symbol_names", ofType: "txt") else { return [""] }
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            return data.components(separatedBy: .newlines).reversed()
        } catch {
            print(error)
        }
        return [""]
    }()

    var searchResults: [String] {
        let icons = filled ? SymbolsView.icons.filter { $0.contains(".fill")} : SymbolsView.icons.filter { !$0.contains(".fill")}
        if searchText.isEmpty {
            return icons
        } else {
            return icons.filter { $0.contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        settings
            .colorMultiply(.blue.mix(with: .white, amount: 0.5))
            .padding(.horizontal)
        ScrollView {
            LazyVStack(alignment: .leading) {
                iconslist
            }
        }
        .padding(.horizontal)
        .searchable(text: $searchText, prompt: "Search")
    }

    var iconslist: some View {
        ForEach(searchResults, id: \.self) { element in
            HStack(alignment: .center) {
                Image(systemName: element)
                    .symbolRenderingMode(multicolor ? .multicolor : .monochrome)
                    .fontWeight(weight)
                    .padding(.horizontal)
                Text(element)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }

    var settings: some View {
        VStack {
            Picker(selection: $weight, label: Text("Weight")) {
                Text("Thin").tag(Font.Weight.thin)
                Text("Regular").tag(Font.Weight.regular)
                Text("Bold").tag(Font.Weight.bold)
                Text("Black").tag(Font.Weight.black)
            }
//            .onChange(of: weight) {
//                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
//            }
            .pickerStyle(.segmented)
            HStack {
                Picker(selection: $filled, label: Text("Fill")) {
                    Text("Filled").tag(true)
                    Text("Unfilled").tag(false)
                }
//                .onChange(of: filled) {
//                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
//                }
                .pickerStyle(.segmented)
                Picker(selection: $multicolor, label: Text("Color")) {
                    Text("Monochrome").tag(false)
                    Text("Multicolor").tag(true)
                }
                .pickerStyle(.segmented)
            }
        }
    }

}

struct SymbolsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { SymbolsView()}
    }
}
