//
//  AppDelegate.swift
//  VolumeRules
//
//  Created by Martti on 21.10.2020.
//  Copyright © 2020 Martti Laine. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var preferencesWindow: NSWindow!

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
        let workspace = NSWorkspace.shared
        workspace.notificationCenter.addObserver(
            self,
            selector: #selector(goingToSleep),
            name: NSWorkspace.willSleepNotification,
            object: nil
        )
        workspace.notificationCenter.addObserver(
            self,
            selector: #selector(awakingFromSleep),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )

        let center = DistributedNotificationCenter.default()
        center.addObserver(
            self,
            selector: #selector(screenIsLocked),
            name: NSNotification.Name(rawValue: "com.apple.screenIsLocked"),
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(screenIsUnlocked),
            name: NSNotification.Name(rawValue: "com.apple.screenIsUnlocked"),
            object: nil
        )
    }
    
    func eventHandler(_ eventName: EventName) {
        NSLog("[\(eventName)] --- Triggered ---")
        let activeOutputDeviceId = AudioDeviceHelper.getActiveDeviceId()
        NSLog("[\(eventName)] activeOutputDeviceId=\(activeOutputDeviceId)")
        let activeOutputDeviceUid = AudioDeviceHelper.getDeviceUid(activeOutputDeviceId)
        NSLog("[\(eventName)] activeOutputDeviceUid=\(activeOutputDeviceUid)")
        let setting = getSetting(eventName, activeOutputDeviceUid)
        NSLog("[\(eventName)] setting=\(String(describing: setting))")
        if setting != nil {
            NSLog("[\(eventName)] Setting volume to \(setting!)")
            AudioDeviceHelper.setDeviceVolume(activeOutputDeviceId, setting!)
        } else {
            NSLog("[\(eventName)] Not setting volume")
        }
        NSLog("[\(eventName)] --- End ---")
    }
    
    @objc func goingToSleep() {
        eventHandler(EventName.goingToSleep)
    }
    
    @objc func awakingFromSleep() {
        eventHandler(EventName.awakingFromSleep)
    }
    
    @objc func screenIsLocked() {
        eventHandler(EventName.lockingScreen)
    }
    
    @objc func screenIsUnlocked() {
        eventHandler(EventName.unlockingScreen)
    }
}

