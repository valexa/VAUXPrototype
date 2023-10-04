//
//  FloatingError.swift
//
//  Created by Vlad Alexa on 10/06/2022.
//  Copyright © 2022 hedgehog lab. All rights reserved.
//

import SwiftUI

struct FloatingError: View {

    @Environment(\.colorScheme) var colorScheme

    @Binding var text: String

    @State var color: Color = .red

    @State var isShowing = false

    var body: some View {
        Group {
            if isShowing {
                error
                    .transition(.scale)
            }
        }
        .onAppear {
            animate(value: text)
        }
        .onChange(of: text) { newValue in
            animate(value: newValue)
        }
    }

    private func animate(value: String) {
        withAnimation(.easeOut) {
            isShowing = !value.isEmpty
        }
    }

    private var error: some View {
        Text(text)
            .font(.body)
        .truncationMode(.tail)
        .accessibility(identifier: text)
        .padding(4)
        .foregroundColor(.primary)
        .background(background)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: 4)
            .foregroundColor(Color(UIColor.systemBackground))
    }

}

struct FloatingError_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FloatingError(text: .constant("error"), isShowing: true)
                .environment(\.locale, Locale(identifier: "en"))
            FloatingError(text: .constant("error"), isShowing: true)
                .preferredColorScheme(.dark)
        }
    }
}
