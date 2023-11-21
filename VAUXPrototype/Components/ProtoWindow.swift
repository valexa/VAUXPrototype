//
//  ProtoWindow.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 22/08/2023.
//

import SwiftUI

struct ProtoWindow: View {
    @ObservedObject var model: PrototypesList
    @Binding var proto: Prototype?

    var body: some View {
        if let protoId = proto, let proto = model[item: protoId] {
            proto.view
        } else {
            Label("Nothing selected", systemImage: "exclamationmark.square.fill")
                .font(.title)
                .foregroundStyle(.tertiary)
        }
    }
}

struct ProtoWindow_Previews: PreviewProvider {
    static var previews: some View {
        let model = PrototypesList()
        Group {
            ProtoWindow(model: model, proto: .constant(nil))
            ProtoWindow(model: model, proto: .constant(.buttons))
        }
    }
}
