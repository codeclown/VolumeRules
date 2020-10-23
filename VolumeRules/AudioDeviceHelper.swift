//
//  AudioDevices.swift
//  VolumeRules
//
//  Created by Martti on 22.10.2020.
//  Copyright © 2020 Martti Laine. All rights reserved.
//

import Foundation
import CoreAudio
import AudioToolbox

// https://chromium.googlesource.com/chromium/src/media/+/7479f0acde23267d810b8e58c07b342719d9a923/audio/mac/audio_manager_mac.cc
// https://stackoverflow.com/questions/4575408/audioobjectgetpropertydata-to-get-a-list-of-input-devices

struct AudioDevice: Identifiable {
    var id: String
    var name: String
}

class AudioDeviceHelper {
    static func listDevices() -> [AudioDevice] {
        var dataSize = UInt32(0)

        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
        )

        let sizeResult = AudioObjectGetPropertyDataSize(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            UInt32(MemoryLayout<AudioObjectPropertyAddress>.size),
            nil,
            &dataSize
        )
        if (sizeResult != 0) {
            print("Error \(sizeResult) from AudioObjectGetPropertyDataSize")
            return []
        }
        
        let deviceAmount = Int(dataSize / UInt32(MemoryLayout<AudioDeviceID>.size))

        var deviceIds = [AudioDeviceID]()
        for _ in 0..<deviceAmount {
            deviceIds.append(AudioDeviceID())
        }
        
        let listResult = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &propertyAddress, 0, nil, &dataSize, &deviceIds);
        if (listResult != 0) {
            print("Error \(listResult) from AudioObjectGetPropertyDataSize")
            return []
        }
        
        var audioDevices: [AudioDevice] = []
        for i in 0..<deviceAmount {
            let audioDevice = AudioDevice(
                id: AudioDeviceHelper.getDeviceUid(deviceIds[i]),
                name: AudioDeviceHelper.getDeviceName(deviceIds[i])
            )
            audioDevices.append(audioDevice)
        }
        return audioDevices;
    }
    
    static func getDeviceUid(_ deviceId: AudioDeviceID) -> String {
        var getDeviceName = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyDeviceUID,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
        )
        var uid: CFString? = nil
        var size: UInt32 = UInt32(MemoryLayout<CFString?>.size)
        let _ = AudioObjectGetPropertyData(
            deviceId,
            &getDeviceName,
            0,
            nil,
            &size,
            &uid
        )
        if uid == nil {
            return ""
        }
        return uid! as String
    }
    
    static func getDeviceName(_ deviceId: AudioDeviceID) -> String {
        var getDeviceName = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyDeviceNameCFString,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
        )
        var name: CFString? = nil
        var size: UInt32 = UInt32(MemoryLayout<CFString?>.size)
        let _ = AudioObjectGetPropertyData(
            deviceId,
            &getDeviceName,
            0,
            nil,
            &size,
            &name
        )
        if name == nil {
            return ""
        }
        return name! as String
    }
    
//    func initForDefaultAudioDevice() {
//        var idSize = UInt32(MemoryLayout.size(ofValue: outputDeviceId))
//        var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
//            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
//            mScope: kAudioObjectPropertyScopeGlobal,
//            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
//        )
//        let _ = AudioObjectGetPropertyData(
//            AudioObjectID(kAudioObjectSystemObject),
//            &getDefaultOutputDevicePropertyAddress,
//            0,
//            nil,
//            &idSize,
//            &outputDeviceId
//        )
//    }
    
//    func setVolume(value: Float32) {
//        var volume = Float32(value)
//        let volumeSize = UInt32(MemoryLayout.size(ofValue: volume))
//        var volumePropertyAddress = AudioObjectPropertyAddress(
//            mSelector: kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
//            mScope: kAudioDevicePropertyScopeOutput,
//            mElement: kAudioObjectPropertyElementMaster
//        )
//        let _ = AudioObjectSetPropertyData(
//            outputDeviceId,
//            &volumePropertyAddress,
//            0,
//            nil,
//            volumeSize,
//            &volume
//        )
//    }
}
