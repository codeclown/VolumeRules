//
//  ContentView.swift
//  VolumeRules
//
//  Created by Martti on 21.10.2020.
//  Copyright © 2020 Martti Laine. All rights reserved.
//

import SwiftUI

struct EventFoobar: View {
    var eventName: EventName
    // TODO fix dropdown not updating the view
    var audioDeviceId: String
    @State var currentValue: Float32?
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            Toggle(
                isOn: Binding<Bool>(
                    get: {
                        return currentValue != nil
                    },
                    set: {
                        let value = $0 ? Float32(0.5) : nil
                        setSetting(eventName, audioDeviceId, value)
                        currentValue = value
                    }
                )
            ) {
                Text(eventLabels[eventName] ?? String(describing: eventName))
            }
            Slider(
                value: Binding<Float32>(
                    get: {
                        return currentValue ?? 0.0
                    },
                    set: {
                        let value = $0
                        setSetting(eventName, audioDeviceId, value)
                        currentValue = value
                    }
                ),
                in: 0...1, step: 0.1
            )
            .disabled(currentValue == nil)
        }
    }
}

struct ContentView: View {
    var audioDevices = AudioDeviceHelper.listDevices()
    @State private var selectedAudioDeviceId = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Audio device:", selection: $selectedAudioDeviceId) {
                ForEach(audioDevices) { audioDevice in
                    Text("\(audioDevice.name) (\(audioDevice.id)").tag(audioDevice.id)
                }
            }
            if selectedAudioDeviceId != "" {
                ForEach(EventName.allCases, id: \.self) { eventName in
                    EventFoobar(
                        eventName: eventName,
                        audioDeviceId: selectedAudioDeviceId,
                        currentValue: getSetting(eventName, selectedAudioDeviceId)
                    )
                }
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
