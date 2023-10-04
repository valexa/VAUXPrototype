//
//  AppIntent.swift
//  ProtoWidget
//
//  Created by vlad on 21/09/2023.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Apple", default: "apple.logo")
    var icon: String

}
