//
//  CtaView.swift
//  HHLUXPrototype
//
//  Created by Vlad Alexa on 10/08/2023.
//

import SwiftUI
import Combine

struct CtaView: View {

    @ObservedObject private var backend = SimulatedBackendSingleton.sharedInstance

    @State private var timerValue = 0.0
    @State private var selectedColor = Color.red
    @State private var colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .cyan, .indigo, .mint, .pink]
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @ObservedObject var favorite0 = FavoriteItem(icon: "flag")
    @ObservedObject var favorite1 = FavoriteItem(icon: "heart")
    @ObservedObject var favorite2 = FavoriteItem(icon: "sun.max")
    @ObservedObject var favorite3 = FavoriteItem(icon: "star")
    @ObservedObject var favorite4 = FavoriteItem(icon: "moon")

    func changeColor(_ item: FavoriteItem) {
        guard !item.isLiked else { return }
        selectedColor = colors[Int.random(in: 0..<10)]
    }

    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            fav1
                .environment(\.isEnabled, !favorite1.isDisabled)
            fav4
                .environment(\.isEnabled, !favorite4.isDisabled)
            fav3
                .environment(\.isEnabled, !favorite3.isDisabled)
            fav2
                .environment(\.isEnabled, !favorite2.isDisabled)
            fav0
                .environment(\.isEnabled, !favorite0.isDisabled)
        }
        .nonSpammable()
        .padding()
        .font(.largeTitle)
    }

    var fav0: some View {
        Image(systemName: favorite0.isDisabled ? favorite0.isFailed ? favorite0.iconFailure : favorite0.iconSuccess : favorite0.icon)
            .onTapGesture {
                withAnimation {
                    changeColor(favorite0)
                    Task { await favorite0.heartTap() }
                }
            }
            .foregroundColor(favorite0.isLiked ? selectedColor : Color.secondary)
            .contentTransition(.symbolEffect(.replace))
    }

    var fav1: some View {
        Image(systemName: favorite1.icon)
            .onTapGesture {
                withAnimation {
                    changeColor(favorite1)
                    Task { await favorite1.heartTapSpammable() }
                }
            }
            .foregroundColor(favorite1.isLiked ? selectedColor : Color.secondary)
    }

    var fav2: some View {
        Image(systemName: favorite2.icon)
            .opacity(favorite2.isDisabled ? 0.5 : 1)
            .onTapGesture {
                changeColor(favorite2)
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
//                .sensoryFeedback(.success, trigger: taskIsComplete)
                Task {
                    await favorite2.heartTap()
                    timerValue = 0.0
                }
            }
            .foregroundColor(favorite2.isLiked ? selectedColor : Color.secondary)
            .overlay {
                if favorite2.isDisabled {
                    progress
                        .offset(y: 2.5)
                }
            }
    }

    var progress: some View {
        VStack {
            Spacer()
            ProgressView(value: timerValue, total: Double(10 * backend.delayValue))
                .onReceive(timer) { _ in
                    if timerValue < Double(10 * backend.delayValue) {
                        timerValue += 1
                    }
                }
                .progressViewStyle(.linear)
                .tint(.gray)
        }
    }

    var fav3: some View {
        Button(action: {
            changeColor(favorite3)
            Task { await favorite3.heartTap() }
        }) {
            Image(systemName: favorite3.icon)
                .opacity(favorite3.isDisabled ? 0.5 : 1)
        }
        .buttonStyle(ScaleBlurButtonStyle())
        .foregroundColor(favorite3.isLiked ? selectedColor : Color.secondary)
    }

    var fav4: some View {
        Button(action: {
            changeColor(favorite4)
            Task { await favorite4.heartTap() }
        }) {
            Image(systemName: favorite4.icon)
                .opacity(favorite4.isDisabled ? 0.5 : 1)
        }
        .buttonStyle(BlurButtonStyle())
        .foregroundColor(favorite4.isLiked ? selectedColor : Color.secondary)
    }

}

struct CtaView_Previews: PreviewProvider {
    static var previews: some View {
        CtaView()
    }
}

struct AntiSpamModifier: ViewModifier {
    @Environment(\.isEnabled) var isEnabled

    func body(content: Content) -> some View {
        content
            .allowsHitTesting(isEnabled)
    }
}

extension View {
    func nonSpammable() -> some View {
        ModifiedContent(content: self, modifier: AntiSpamModifier())
    }
}

struct ScaleBlurButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .blur(radius: configuration.isPressed ? 2 : 0 )
    }
}

struct BlurButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .blur(radius: configuration.isPressed ? 2 : 0 )
    }
}

@MainActor
class FavoriteItem: ObservableObject {

    @State private var backend = SimulatedBackendSingleton.sharedInstance

    var icon: String = ""
    let iconSuccess: String = "checkmark"
    let iconFailure: String = "exclamationmark.triangle"

    @Published var isLiked = false
    @Published var isDisabled = false
    @Published var isFailed = false

    init(icon: String) {
        self.icon = icon
    }

    func heartTap() async {
        isFailed = backend.willFail || backend.willTimeout
        isDisabled = true
        if backend.willTimeout { return }
        try? await Task.sleep(nanoseconds: UInt64(backend.delayValue * 1_000_000_000))
        withAnimation(.easeIn) {
            isDisabled = false
            isFailed = backend.willFail || backend.willTimeout
            if isFailed {
                isLiked = false
            } else {
                isLiked.toggle()
            }
        }
    }

    func heartTapSpammable() async {
        isFailed = backend.willFail || backend.willTimeout
        if backend.willTimeout { return }
        try? await Task.sleep(nanoseconds: UInt64(backend.delayValue * 1_000_000_000))
        withAnimation(.easeIn) {
            isFailed = backend.willFail || backend.willTimeout
            if isFailed {
                isLiked = false
            } else {
                isLiked.toggle()
            }
        }
    }

}
