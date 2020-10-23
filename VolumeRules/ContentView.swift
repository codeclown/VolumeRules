//
//  ContentView.swift
//  VolumeRules
//
//  Created by Martti on 21.10.2020.
//  Copyright © 2020 Martti Laine. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var audioDevices = AudioDeviceHelper.listDevices()
    @State private var selectedAudioDeviceId = AudioDeviceHelper.getDeviceUid(AudioDeviceHelper.getActiveDeviceId())
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Audio device:", selection: $selectedAudioDeviceId) {
                ForEach(audioDevices) { audioDevice in
                    Text("\(audioDevice.name) (\(audioDevice.id)").tag(audioDevice.id)
                }
            }
            if selectedAudioDeviceId != "" {
                ForEach(EventName.allCases, id: \.self) { eventName in
                    EventPreferences(
                        eventName: eventName,
                        audioDeviceId: selectedAudioDeviceId,
                        currentValue: getSetting(eventName, selectedAudioDeviceId)
                    )
                    .id("\(selectedAudioDeviceId) \(eventName)")
                }
            }
        }
        .padding()
    }
}

struct EventPreferences: View {
    var eventName: EventName
    var audioDeviceId: String
    @State var currentValue: Float32?
    
    private var isOn: Binding<Bool> {
        Binding(
            get: {
                return currentValue != nil
            },
            set: {
                let value = $0 ? Float32(0.0) : nil
                currentValue = value
                setSetting(eventName, audioDeviceId, value)
            }
        )
    }
    
    private var sliderValue: Binding<Float32> {
        Binding(
            get: {
                currentValue ?? 0.0
            },
            set: {
                let value = $0
                currentValue = value
                setSetting(eventName, audioDeviceId, value)
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            Toggle(isOn: isOn) {
                Text(eventLabels[eventName] ?? String(describing: eventName))
            }
            Slider(value: sliderValue, in: 0...1, step: 0.1)
            .disabled(currentValue == nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
