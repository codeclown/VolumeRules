//
//  ContentView.swift
//  VolumeRules
//
//  Created by Martti on 21.10.2020.
//  Copyright © 2020 Codeclown. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var preferences = UserPreferences()
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $preferences.goingToSleepEnabled) {
                Text("When Mac goes to sleep, set volume to…")
            }
            Slider(value: $preferences.goingToSleepLevel, in: 0...1, step: 0.1)
            Divider()
            Toggle(isOn: $preferences.awakingFromSleepEnabled) {
                Text("When Mac awakes from sleep, set volume to…")
            }
            Slider(value: $preferences.awakingFromSleepLevel, in: 0...1, step: 0.1)
//            "Why so many options? Keep in mind that Mac remembers volume per-device. For example, if you set a specific volume when the Mac goes to sleep and is connected to e.g. a Bluetooth speaker, and then disconnects from that speaker before waking up, the wake-up device will be different and the volume."
//            "Note that volume is device-specific. So, if you set a rule for when Mac goes to sleep, and your output device disconnects before it awakes, that rule changed the volume of the previous device but not the new one."
//            "Note that volume is device-specific. Meaning, it gets applied to whichever output device is active when the rule is activated. If you Mac switches to another output device afterwards, volume will reset to whichever is set for that device."
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
