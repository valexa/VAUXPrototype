//
//  PickersView.swift
//  HHLUXPrototype
//
//  Created by Vlad Alexa on 17/08/2023.
//

import SwiftUI

struct PickersView: View {

    @Environment(\.calendar) var calendar
    @State var dates: Set<DateComponents> = []

    @State private var bgColor =
            Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)

    var body: some View {
        List {
            Section("Color Picker") {
                ColorPicker(bgColor.description, selection: $bgColor)
            }
            Section("Multi Date picker") {
                VStack {
                    MultiDatePicker("Select your preferred dates", selection: $dates)
                    Text(datesSummary)
                }
                .padding()
            }
            Section("Page control horizontal") {
                pages
            }
            Section("Page control vertical") {
                pagesRotated
            }
            Section("Share links") {
                ShareLink(item: URL(string: "http://apple.com")!)
                ShareLink(item: URL(string: "http://apple.com")!) {
                    Label("Custom icon share", systemImage: "rectangle.3.group.bubble.left.fill")
                }
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        }
    }

    var datesSummary: String {
        dates.compactMap { components in
            calendar.date(from: components)?.formatted(date: .long, time: .omitted)
        }
        .formatted()
    }

    var pages: some View {
        TabView {
            Group {
                ForEach(1..<7) { index in
                    Text("Page \(index)")
                }
            }
        }
        .tabViewStyle(.page)
        .frame(width: 400, height: 100)
    }

    var pagesRotated: some View {
        TabView {
            Group {
                ForEach(1..<7) { index in
                    Text("Page \(index)")
                }
            }
            .rotationEffect(Angle(degrees: -90))
            .offset(y: -20)

        }
        .rotationEffect(Angle(degrees: 90))
        .frame(width: 400, height: 100)
        .tabViewStyle(.page)
    }

}

#Preview {
    PickersView()
        .environmentObject(AppSettings())
}
