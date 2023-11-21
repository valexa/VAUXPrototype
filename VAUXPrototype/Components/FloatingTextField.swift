//
//  FloatingTextField.swift
//
//  Created by Rajat Kumar - Work on 12/05/22.
//  Copyright © 2022 hedgehog lab. All rights reserved.
//

import SwiftUI
import Combine

struct FloatingTextField: View {
    enum Field: Int, Hashable {
        case current
    }

    @Environment(\.colorScheme) var colorScheme

    // Floating Placeholder text
    let title: String

    // TextField text
    @Binding var text: String

    @Binding var error: String

    @State var secure = false

    @FocusState private var focusedField: Field?

    var style: FloatingTextFieldStyle {
        FloatingTextFieldStyle.default(colorScheme: colorScheme)
    }

    var body: some View {
        ZStack {
            // Background and Border
            style.backgroundColor.ignoresSafeArea()
                .cornerRadius(style.cornerRadius)
                .overlay { rectangle }
            floatingLabel
            textField
        }
        .opacity(error.isEmpty ? 1 : 0.7)
        .colorMultiply(error.isEmpty ? .white : .red)
        .frame(height: style.height)
        .padding([.leading, .trailing])
        .overlay {
            errorField
                .offset(y: -24)
        }
    }

    private var errorField: some View {
        FloatingError(text: $error)
            .padding(.horizontal, style.internalPadding)
            .lineLimit(1)

    }

    private var rectangle: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .stroke(focusedField == .current ? style.borderColorWhenFocused : style.borderColor, lineWidth: style.borderWidth)
    }

    private var textField: some View {
        Group {
            if secure {
                SecureTextFieldWithReveal("", text: $text)
                    .padding(.trailing)
            } else {
                TextField("", text: $text)
                    .autocorrectionDisabled()
            }
        }
        .foregroundColor(style.textColor)
        .padding(.leading, style.internalPadding)
        .padding(.top)
        .focused($focusedField, equals: .current)
        .onTapGesture {
            clearError()
            withAnimation {
                focusedField = .current
            }
        }
        .onSubmit {
            focusedField = nil
        }
        .accessibility(identifier: title)
    }

    private func clearError() {
        if !error.isEmpty {
            Task {
                await MainActor.run {
                    text = ""
                    error = ""
                }
            }
        }
    }

    private var floatingLabel: some View {
        HStack {
            Text(title)
                .font(focusedField == .current || !$text.wrappedValue.isEmpty ? .caption : .body)
                .foregroundColor(focusedField == .current ? style.placeholderColor : style.placeholderColor.opacity(0.5))
                .offset(x: 0,
                        y: placeholderOffset)
                .transition(.slide)
                .transition(.scale)

            Spacer()
        }
        .animation(.easeInOut(duration: 0.25), value: title)
        .padding(.leading, style.internalPadding)
    }

    var placeholderOffset: CGFloat {
        focusedField == .current || !$text.wrappedValue.isEmpty ? style.placeholderOffset : 0
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            preview
                .preferredColorScheme(.dark)
            preview
                .preferredColorScheme(.light)
        }
    }
    static var preview: some View {
        VStack {
            FloatingTextField(title: "Password", text: .constant(""), error: .constant(""), secure: true)
            FloatingTextField(title: "First Name", text: .constant(""), error: .constant(""))
            FloatingTextField(title: "Last Name", text: .constant(""), error: .constant(""))
            FloatingTextField(title: "First Name", text: .constant("Foo"), error: .constant(""))
            FloatingTextField(title: "Last Name", text: .constant("Bar"), error: .constant(""))
            FloatingTextField(title: "First Name", text: .constant("Sh"), error: .constant("Name too short"))
            FloatingTextField(title: "Last Name", text: .constant("Bool"), error: .constant("Somewhat longer longer error message"))
        }
    }
}

struct FloatingTextFieldStyle {

    static func `default`(colorScheme: ColorScheme = .light) -> FloatingTextFieldStyle {
        var style = FloatingTextFieldStyle()
        let isLightMode = colorScheme == .light
        style.borderColor = isLightMode ? .black.opacity(0.1) : .white.opacity(0.2)
        style.borderColorWhenFocused = isLightMode ? .black : .white
        style.backgroundColor = isLightMode ? .white : .white.opacity(0.2)
        return style
    }

    var cornerRadius: CGFloat = 8.0
    var borderWidth: CGFloat = 1.5
    var internalPadding: CGFloat = 20.0
    var height: CGFloat = 60.0
    var placeholderOffset: CGFloat = -15.0

    var borderColor: Color = Color(.systemBackground)
    var borderColorWhenFocused: Color = .white
    var backgroundColor: Color = Color(.systemBackground)
    var placeholderColor: Color = .primary
    var textColor: Color = .primary
}
