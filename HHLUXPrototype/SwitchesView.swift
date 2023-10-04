//
//  SwitchesView.swift
//  HHLUXPrototype
//
//  Created by Vlad Alexa on 14/08/2023.
//

import SwiftUI

struct SwitchesView: View {

    @ObservedObject private var backend = SimulatedBackendSingleton.sharedInstance

    @EnvironmentObject private var appSettings: AppSettings

    let start = Date().addingTimeInterval(-360)
    let end = Date().addingTimeInterval(360)

    @State private var value = 0.0

    @State private var speed = 50.0
    @State private var isEditing = false

    @State private var batteryLevel = 90.0

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Toggle("Switch Toggle (orange tint)", isOn: $appSettings.defaults.orangeTint)
                        .toggleStyle(.switch)
                    Toggle("Button Toggle (orange tint)", isOn: $appSettings.defaults.orangeTint)
                        .toggleStyle(.button)
                }
            }
            Section {
                stepper
            }
            Section {
                slider
            }
            Section {
                progress
            }
            Section("Gauges") {
                gauges
            }
            Section("Variable Symbols") {
                symbols
            }
        }
        .ifModifier(appSettings.defaults.orangeTint) { view in
            view.tint(.orange)
        }
    }

    var gauge: some View {
        Gauge(value: batteryLevel, in: 0...100) {
            Text("")
        } currentValueLabel: {
            Text("\(Int(batteryLevel))")
        } minimumValueLabel: {
            Text("0")
        } maximumValueLabel: {
            Text("100")
        }
    }
    var gauges: some View {
        VStack {
            HStack {
                gauge
                gauge
                .gaugeStyle(.accessoryCircular)
                gauge
                .gaugeStyle(.accessoryCircularCapacity)
            }
            HStack {
                gauge
                    .gaugeStyle(.accessoryLinear)
                gauge
                    .gaugeStyle(.accessoryLinearCapacity)
            }
        }
    }

    var stepper: some View {
        Stepper {
            Text("Stepper: \(value)")
        } onIncrement: {
            value += 1
        } onDecrement: {
            value -= 1
        }
    }

    var slider: some View {
        HStack {
            Text("Slider: \(Int(speed))")
                .foregroundColor(isEditing ? .gray : .black)
            Slider(value: $speed, in: 0...100) { editing in
                isEditing = editing
            }
        }
    }

    var progress: some View {
        ProgressView(timerInterval: start...end,
                     countsDown: false) {
            Text("Progress bar")
        } currentValueLabel: {
            Text(start...end)
        }
    }

    var symbols: some View {
        VStack {
            HStack {
                Image(systemName: "bell.badge.waveform", variableValue: value)
                Image(systemName: "aqi.low", variableValue: value)
                Image(systemName: "wifi", variableValue: value)
                Image(systemName: "chart.bar.fill", variableValue: value)
                Image(systemName: "shareplay", variableValue: value)
                Image(systemName: "waveform", variableValue: value)
                Image(systemName: "timelapse", variableValue: value)
                Image(systemName: "cloud.rainbow.half", variableValue: value)
            }
            Slider(value: $value)
                .padding(.horizontal)
        }
        .font(.title)
        .padding()
    }

}

struct SwitchesView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchesView()
            .environmentObject(AppSettings())
    }
}
