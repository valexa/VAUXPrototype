//
//  StatesView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 10/08/2023.
//

import SwiftUI

struct StatesView: View {

    var body: some View {
        List {
            Section("Ready") {
                HStack(spacing: 10) {
                    Button("Press to get a quote shown to my right") {
                    }
                    .buttonStyle(.standardPrimary)
                    Text("Quote placeholder")
                        .padding()
                        .foregroundColor(.secondary)
                }
            }
            Section("Loading") {
                HStack(spacing: 10) {
                    Button("I was pressed and am now disabled while loading") {
                    }
                    .buttonStyle(.standardPrimaryDisabled)
                    ProgressView()
                    Text("Quote is loading")
                }

            }
            Section("Error") {
                HStack(spacing: 10) {
                    Button("I was pressed and got a error") {
                    }
                    .buttonStyle(.standardPrimary)
                    Text("Quote retrieval failed because of this and that")
                        .foregroundColor(.red)
                }
            }
            Section("Success") {
                HStack(spacing: 10) {
                    Button("I was pressed and got a quote") {
                    }
                    .buttonStyle(.standardPrimary)
                    Text("You must unlearn what you have learned. Yoda")
                        .bold()
                }
            }
            Section(header: Text("Empty"), footer: details) {
                HStack(spacing: 10) {
                    Button("I was pressed but did not find a quote") {
                    }
                    .buttonStyle(.standardPrimary)
                    Image(systemName: "exclamationmark.triangle")
                    Text("No quote found")
                }
            }
        }
        .listStyle(.grouped)
    }

    var details: some View {
        Text("Typically UI will transition through a variation of the above 5 states (ready, loading, error, success, empty)")
            .foregroundColor(.secondary)
            .font(.footnote)
            .padding(.top, 50)
    }
}

struct StatesView_Previews: PreviewProvider {
    static var previews: some View {
        StatesView()
    }
}
