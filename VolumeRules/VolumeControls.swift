//
//  VolumeControls.swift
//  VolumeRules
//
//  Created by Martti on 21.10.2020.
//  Copyright © 2020 Martti Laine. All rights reserved.
//

import Foundation
import CoreAudio
import AudioToolbox

class VolumeControls {
    var outputDeviceId = AudioDeviceID(0);
    
    
    func isBuiltInOutput() -> Bool {
        var getDeviceName = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyDeviceNameCFString,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
        )
        var name: CFString? = nil
        var propsize: UInt32 = UInt32(MemoryLayout<CFString?>.size)
        let _ = AudioObjectGetPropertyData(
            outputDeviceId,
            &getDeviceName,
            0,
            nil,
            &propsize,
            &name
        )
        if name == nil {
            return false
        }
        let nameString: NSString = name!;
        return nameString == "Built-in Output";
    }
}
