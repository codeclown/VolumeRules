//
//  VolumeControls.swift
//  VolumeRules
//
//  Created by Martti on 21.10.2020.
//  Copyright © 2020 Codeclown. All rights reserved.
//

import Foundation
import CoreAudio
import AudioToolbox

class VolumeControls {
    var outputDeviceId = AudioDeviceID(0);
    
    func initForDefaultAudioDevice() {
        var idSize = UInt32(MemoryLayout.size(ofValue: outputDeviceId))
        var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
        )
        let _ = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &getDefaultOutputDevicePropertyAddress,
            0,
            nil,
            &idSize,
            &outputDeviceId
        )
    }
    
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
    
    func setVolume(value: Float32) {
        var volume = Float32(value)
        let volumeSize = UInt32(MemoryLayout.size(ofValue: volume))
        var volumePropertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMaster
        )
        let _ = AudioObjectSetPropertyData(
            outputDeviceId,
            &volumePropertyAddress,
            0,
            nil,
            volumeSize,
            &volume
        )
    }
}
