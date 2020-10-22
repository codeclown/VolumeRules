//
//  UserPreferences.swift
//  VolumeRules
//
//  Created by Martti on 21.10.2020.
//  Copyright © 2020 Codeclown. All rights reserved.
//

import Foundation
import Combine

// Thanks to:
// https://stackoverflow.com/a/57029469/239527

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            if let value = UserDefaults.standard.object(forKey: key) as? T {
                return value
            }
            return defaultValue
        }
        set {
            NSLog("Setting \(key) to \(newValue)")
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserPreferences: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    // Going to sleep
    
    @UserDefault("GOING_TO_SLEEP_ENABLED", defaultValue: false)
    var goingToSleepEnabled: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("GOING_TO_SLEEP_LEVEL", defaultValue: 0.0)
    var goingToSleepLevel: Float32 {
        willSet {
            objectWillChange.send()
        }
    }

    // Awaking from sleep
    
    @UserDefault("AWAKING_FROM_SLEEP_ENABLED", defaultValue: false)
    var awakingFromSleepEnabled: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("AWAKING_FROM_SLEEP_LEVEL", defaultValue: 0.0)
    var awakingFromSleepLevel: Float32 {
        willSet {
            objectWillChange.send()
        }
    }
}
