//
//  SecureTextFieldWithReveal.swift
//
//  Created by Stoyan Stoyanov on 20/05/22.
//  Copyright © 2022 hedgehog lab. All rights reserved.
//

import SwiftUI

struct SecureTextFieldWithReveal: View {
    let titleKey: String
    let contentType: UITextContentType
    @Binding var text: String

    @State private var showPassword = false
    @FocusState private var focusNonSecure: Bool
    @FocusState private var focusSecure: Bool

    init(_ titleKey: String, text: Binding<String>, contentType: UITextContentType = .password) {
        self.titleKey = titleKey
        self.contentType = contentType
        self._text = text
    }

    var body: some View {
        HStack {
            textField
            eyeButton
        }
    }

    var textField: some View {
        Group {
            if showPassword {
                TextField(titleKey, text: $text)
                    .focused($focusNonSecure)
            } else {
                SecureField(titleKey, text: $text)
                    .focused($focusSecure)
            }
        }
        .disableAutocorrection(true)
        .autocapitalization(.none)
        .textContentType(contentType)
    }

    var eyeButton: some View {
        Button(action: {
            showPassword.toggle()
            focusNonSecure = showPassword
            focusSecure = !showPassword
        }, label: {
            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                .font(.system(size: 16, weight: .regular))
                .padding([.leading, .vertical])
        })
    }

}

struct SecureTextFieldWithReveal_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            field
                .environment(\.locale, Locale(identifier: "en"))
            field
                .preferredColorScheme(.dark)
            field
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }

    static var field: some View {
        SecureTextFieldWithReveal("Password", text: .constant("test"))
    }
}
