//
//  AppDelegate.swift
//  VolumeRules
//
//  Created by Martti on 21.10.2020.
//  Copyright © 2020 Codeclown. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var preferences = UserPreferences()

    var statusBarItem: NSStatusItem!
    var preferencesWindow: NSWindow!
    
    var volumeControls = VolumeControls()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupUi();
        setupListeners();
    }
    
    // UI
    
    func setupUi() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Preferences", action: #selector(openPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit VolumeRules", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.menu = menu
        if let button = statusBarItem.button {
            button.image = NSImage(named: "Status Bar Icon")
        }
        
        preferencesWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        preferencesWindow.isReleasedWhenClosed = false
        preferencesWindow.title = "VolumeRules"
        
        let contentView = ContentView()
        preferencesWindow.contentView = NSHostingView(rootView: contentView)
    }
    
    @objc func openPreferences(_ sender: AnyObject?) {
        preferencesWindow.center()
        preferencesWindow.makeKeyAndOrderFront(sender)
    }
    
    // Listeners
    
    func setupListeners() {
        volumeControls.initForDefaultAudioDevice();
        
        let workspace = NSWorkspace.shared
        workspace.notificationCenter.addObserver(self, selector: #selector(goingToSleep), name: NSWorkspace.willSleepNotification, object: nil)
        workspace.notificationCenter.addObserver(self, selector: #selector(awakingFromSleep), name: NSWorkspace.didWakeNotification, object: nil)

//        let center = DistributedNotificationCenter.default()
//        center.addObserver(self, selector: #selector(screenIsLocked), name: NSNotification.Name(rawValue: "com.apple.screenIsLocked"), object: nil)
//        center.addObserver(self, selector: #selector(screenIsUnlocked), name: NSNotification.Name(rawValue: "com.apple.screenIsUnlocked"), object: nil)
    }
    
    @objc func goingToSleep() {
        NSLog("[goingToSleep] Triggered")
        if !preferences.goingToSleepEnabled {
            NSLog("[goingToSleep] Not enabled, aborting.")
            return
        }
        NSLog("[goingToSleep] Setting volume to \(preferences.goingToSleepLevel)")
        volumeControls.setVolume(value: preferences.goingToSleepLevel);
    }
    
    @objc func awakingFromSleep() {
        NSLog("[awakingFromSleep] Triggered")
        if !preferences.awakingFromSleepEnabled {
            NSLog("[awakingFromSleep] Not enabled, aborting.")
            return
        }
        NSLog("[awakingFromSleep] Setting volume to \(preferences.awakingFromSleepLevel)")
        volumeControls.setVolume(value: preferences.awakingFromSleepLevel);
    }
}

