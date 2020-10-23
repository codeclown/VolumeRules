//
//  Config.swift
//  VolumeRules
//
//  Created by Martti on 23.10.2020.
//  Copyright © 2020 Martti Laine. All rights reserved.
//

import Foundation
import SwiftUI

enum EventName: CaseIterable {
    case goingToSleep
    case awakingFromSleep
    case lockingScreen
    case unlockingScreen
}

let eventLabels: Dictionary<EventName, String> = [
    EventName.goingToSleep: "When Mac goes to sleep, set volume to…",
    EventName.awakingFromSleep: "When Mac awakes from sleep, set volume to…",
    EventName.lockingScreen: "When screen is locked, set volume to…",
    EventName.unlockingScreen: "When screen is unlocked, set volume to…"
]

class UiStrings {
    static var menuItemPreferences = "Preferences"
    static var menuItemQuit = "Quit VolumeRules"
    static var preferencesWindowTitle = "VolumeRules Preferences"
    static var audioDevicePickerLabel = "Audio device:"
}
