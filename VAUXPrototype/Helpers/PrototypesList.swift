//
//  PrototypesList.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 22/08/2023.
//

import SwiftUI
import Combine

class PrototypesList: ObservableObject {

    @Published var items: [Prototype]
    let categories: [Category]

    init(
        items: [Prototype] = .mocks,
        categories: [Category] = .mocks
    ) {
        self.items = items
        self.categories = categories
    }

    subscript(item id: Prototype.ID) -> Prototype? {
        items.first { $0.id == id }
    }

    subscript(category category: Category) -> [Prototype] {
        switch category {
        case .primary: [.buttons, .selectors, .switches, .pickers, .input, .lists]
        case .secondary: [.popups, .tips, .menus, .loading]
        case .extra: [.states, .symbols]
        case .ipad: [.multitasking]
        }
    }

}

enum Category: Int, CaseIterable, Codable, Identifiable {
    case primary
    case secondary
    case extra
    case ipad

    var id: Self { self }

    var title: String {
        switch self {
        case .primary: "Components"
        case .secondary: "Behaviour"
        case .extra: "Extra"
        case .ipad: "iPadOS"
        }
    }
}

enum Prototype: String, CaseIterable, Codable, Identifiable {
    case buttons
    case selectors
    case switches
    case pickers
    case input
    case popups
    case tips
    case lists
    case menus
    case haptics
    case loading
    case states
    case symbols
    case multitasking

    var id: Self { self }

    @ViewBuilder
    var view: some View {
        switch self {
        case .buttons: CtaViewList()
        case .selectors: SelectorsView()
        case .switches: SwitchesView()
        case .pickers: PickersView()
        case .input: InputView()
        case .popups: PopupsView()
        case .tips: TipsView()
        case .lists: ListsView()
        case .menus: MenuView()
#if os(iOS)
        case .haptics: HapticsView()
#else
        case .haptics: EmptyView()
#endif
        case .loading: LoadView()
        case .states: StatesView()
        case .symbols: SymbolsView()
        case .multitasking: MultitaskingView()
        }
    }

    var title: String {
        switch self {
        case .buttons: "Buttons"
        case .selectors: "Selectors"
        case .switches: "Switches, sliders, gauges"
        case .pickers: "Pickers, Pages, share"
        case .input: "Text input"
        case .popups: "Popups"
        case .tips: "Tips"
        case .lists: "Lists"
        case .menus: "Menus"
        case .haptics: "Haptics"
        case .loading: "Loading"
        case .states: "States"
        case .symbols: "SF Symbols"
        case .multitasking: "Multitasking"
        }
    }

    var iconName: String {
        switch self {
        case .buttons: "rectangle.and.hand.point.up.left"
        case .selectors: "checklist"
        case .switches: "switch.2"
        case .pickers: "eyedropper"
        case .input: "rectangle.and.pencil.and.ellipsis"
        case .popups: "rectangle.on.rectangle.angled"
        case .tips: "rectangle.3.group.bubble.left.fill"
        case .lists: "list.bullet.rectangle"
        case .menus: "filemenu.and.selection"
        case .haptics: "hand.tap"
        case .loading: "arrow.clockwise.icloud"
        case .states: "checkmark.circle.trianglebadge.exclamationmark"
        case .symbols: "apple.logo"
        case .multitasking: "rectangle.split.2x1.fill"
        }
    }
}

extension Prototype {

    func makeShortcut() -> UIApplicationShortcutItem {
        UIApplicationShortcutItem(type: rawValue, localizedTitle: title, localizedSubtitle: "",
                                  icon: UIApplicationShortcutIcon(systemImageName: iconName),
                                  userInfo: nil)
    }

    init?(shortcut: UIApplicationShortcutItem) {
        self.init(rawValue: shortcut.type)
    }

    init?(activity: NSUserActivity) {
        self.init(rawValue: activity.activityType)
    }

}

extension Collection where Element == Prototype {
    static var mocks: [Prototype] {
        Prototype.allCases
    }
}

extension Collection where Element == Category {
    static var mocks: [Category] {
        Category.allCases
    }
}
