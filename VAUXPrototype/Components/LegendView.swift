//
//  LegendView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 13/08/2023.
//

import SwiftUI

struct LegendView: View {

    enum Types {
        case label
        case scale
        case style
        case color
    }

    @State private var isShowingLegend = false
    @State private var legendText = ""

    @ViewBuilder func makeLegend(label: String, types: [Types]) -> some View {
        HStack {
            Text(label)
            Spacer()
            ForEach(types, id: \.self) { type in
                if type == .label { buttonLabel }
                if type == .scale { buttonScale }
                if type == .style { buttonStyle }
                if type == .color { buttonColor }
            }
            .foregroundColor(.secondary)
            .opacity(0.1)
            Spacer()
        }
    }

    var body: some View {
        HStack {
            buttonLabel
            buttonScale
            buttonStyle
            buttonColor
        }
        .sheet(isPresented: $isShowingLegend) {
            Group {
                legendLabel
            }
            .presentationDetents([.medium, .large])
        }
        .foregroundColor(.secondary)
        .opacity(0.2)
    }

    var legendLabel: some View {
        Text("A textual label available for the component is fully customisable in that it can be shown/hidden")
    }

    var buttonLabel: some View {
        Button(action: {
            isShowingLegend.toggle()
        }) {
            Image(systemName: "l.square.fill")
        }
    }

    var legendScale: some View {
        Text("The component can be scaled")
    }

    var buttonScale: some View {
        Button(action: {
            isShowingLegend.toggle()
        }) {
            Image(systemName: "square.arrowtriangle.4.outward")
        }
    }

    var legendStyle: some View {
        Text("Text style is fully customisable")
    }

    var buttonStyle: some View {
        Button(action: {
            isShowingLegend.toggle()
        }) {
            Image(systemName: "textformat.size")
        }
    }

    var legendColor: some View {
        Text("Color is fully customisable")
    }

    var buttonColor: some View {
        Button(action: {
            isShowingLegend.toggle()
        }) {
            Image(systemName: "paintpalette.fill")
        }
    }

}

struct LegendView_Previews: PreviewProvider {
    static var previews: some View {
        LegendView()
    }
}
