//
//  ProtoWidget.swift
//  ProtoWidget
//
//  Created by vlad on 21/09/2023.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct ProtoWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Icon:")
            Image(systemName: entry.configuration.icon)
        }
    }
}

struct ProtoWidget: Widget {
    let kind: String = "ProtoWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ProtoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    static var hand: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.icon = "hand.tap"
        return intent
    }

    static var eye: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.icon = "eye"
        return intent
    }
}

#Preview(as: .systemSmall) {
    ProtoWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .hand)
    SimpleEntry(date: .now, configuration: .eye)
}
