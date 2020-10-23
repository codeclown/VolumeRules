//
//  Settings.swift
//  VolumeRules
//
//  Created by Martti on 23.10.2020.
//  Copyright © 2020 Martti Laine. All rights reserved.
//

import Foundation

func userDefaultsKey(_ eventName: EventName, _ audioDeviceId: String) -> String {
    return "\(eventName)::\(audioDeviceId)"
}

func getSetting(_ eventName: EventName, _ audioDeviceId: String) -> Float32? {
    let key = userDefaultsKey(eventName, audioDeviceId)
    if UserDefaults.standard.object(forKey: key) == nil {
        return nil
    }
    return UserDefaults.standard.float(forKey: key)
}

func setSetting(_ eventName: EventName, _ audioDeviceId: String, _ value: Float32?) {
    let key = userDefaultsKey(eventName, audioDeviceId)
    if value == nil {
        NSLog("[setSetting] Removing value \(key)")
        return UserDefaults.standard.removeObject(forKey: key)
    } else {
        NSLog("[setSetting] Setting value \(key) to \(value!)")
        return UserDefaults.standard.set(value!, forKey: key)
    }
}
