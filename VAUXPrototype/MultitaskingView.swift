//
//  MultitaskingView.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 21/08/2023.
//

import SwiftUI

struct MultitaskingView: View {
    var body: some View {
        List {
            Label("Split View: In Split View, two apps appear side-by-side. You can resize the apps by dragging the slider that appears between them.", systemImage: "rectangle.lefthalf.inset.filled")
                .foregroundColor(.secondary)
            Label("Slide Over: With Slide Over, one app appears in a smaller floating window that you can drag to the left or right side of your screen.", systemImage: "rectangle.rightthird.inset.filled")
                .foregroundColor(.secondary)
            Label("Center window: In some apps, you can open a center window that lets you focus on a specific item, such as an email or a note.", systemImage: "rectangle.center.inset.filled")
                .foregroundColor(.secondary)
            Link(" HIG link ⤴", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines/multitasking")!)
            Link(" KB link ⤴", destination: URL(string: "https://support.apple.com/en-us/HT207582")!)
        }
    }
}

#Preview {
    MultitaskingView()
}
