//
//  SimulatedBackendSingleton.swift
//  VAUXPrototype
//
//  Created by Vlad Alexa on 15/08/2023.
//

import SwiftUI

final class SimulatedBackendSingleton: NSObject, ObservableObject {

    @Published var willFail = false {
        willSet {
            if newValue {
                willTimeout = false
            }
        }
    }

    @Published var willTimeout = false {
        willSet {
            if newValue {
                willFail = false
            }
        }
    }

    @Published var delayValue = 1

    static let sharedInstance = SimulatedBackendSingleton()

    private override init() {
        super.init()
    }

}
