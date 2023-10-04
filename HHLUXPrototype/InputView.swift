//
//  InputView.swift
//  HHLUXPrototype
//
//  Created by Vlad Alexa on 10/08/2023.
//

import SwiftUI

struct InputView: View {

    @State var text = "This is a multiline textfield that is configured for content to scroll vertically, it can be configured with a minimum and maximum line limit, this one for example is set to 8-80"
    @State var textSingle = "This is a single line textfield that is configured for content to scroll horizontally "

    @State var typing = false

    var feedback: some View {
        Image(systemName: "rectangle.stack")
            .symbolEffect(.bounce.byLayer, value: typing)
    }

    var body: some View {
        VStack {
            feedback
            List {
                Section("Standard single line, .horizontal") {
                    TextField("", text: $textSingle) {
                        typing = $0
                    }
                }
                Section("Standard multiline, .vertical") {
                    TextField("", text: $text, axis: .vertical)
                        .lineLimit(8...80)
                }
            }
            List {
                Section("Custom vertical one line field, empty state") {
                    FloatingTextField(title: "Username placeholder", text: .constant(""), error: .constant(""))
                }
                .listRowBackground(Color.clear)
                Section("Custom vertical one line field, Ready state") {
                    FloatingTextField(title: "Username", text: .constant("something"), error: .constant(""))
                }
                .listRowBackground(Color.clear)
                Section("Custom vertical one line field, Error state") {
                    FloatingTextField(title: "Username", text: .constant("invalid"), error: .constant("some error"))
                }
                .listRowBackground(Color.clear)
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
    }

}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
