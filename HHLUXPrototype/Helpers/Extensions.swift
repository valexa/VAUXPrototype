//
//  View+Extension.swift
//  HHLUXPrototype
//
//  Created by Vlad Alexa on 12/08/2023.
//

import SwiftUI

extension View {
    @ViewBuilder func `ifModifier`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    var swiftuiVersionNumber: String {
        let bundle = Bundle.allFrameworks.filter { $0.bundlePath.contains("SwiftUI.framework") }
        return bundle.first?.releaseVersionNumber ?? ""
    }
}
