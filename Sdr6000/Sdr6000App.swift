//
//  Sdr6000App.swift
//  Sdr6000
//
//  Created by Douglas Adams on 6/3/23.
//

import SwiftUI

import Dax2Panel
import FlexApi
import Listener
import RxAVAudioPlayer
import SettingsModel
import SettingsPanel
import SidePanel
import SharedModel

public enum WindowType: String {
  case controls = "Controls"
  case dax = "Dax"
  case settings = "Settings"
}

final class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    // disable tab view
    NSWindow.allowsAutomaticWindowTabbing = false
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    SettingsModel.shared.save()
    closeAuxiliaryWindows()
    log("Sdr6000: application terminated", .debug, #function, #file, #line)
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    true
  }
}

@main
struct Sdr6000App: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  var appDelegate
  
  @State var api = ApiModel.shared
  @State var settings = SettingsModel.shared
  @State var listener = Listener.shared
  @State var rxAVAudioPlayer = RxAVAudioPlayer.shared

  var body: some Scene {
    
    // Main window
    WindowGroup("") {
      SdrView()
        .environment(api)
        .environment(listener)
        .environment(settings)
        .environment(SdrModel(api, listener, settings, rxAVAudioPlayer))
        .environment(rxAVAudioPlayer)
    }
    
    // Controls window
    Window(WindowType.controls.rawValue, id: WindowType.controls.rawValue) {
      SideView()
        .environment(api)
        .environment(settings)
        .frame(minHeight: 210)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(WindowResizability.contentSize)
    .defaultPosition(.topTrailing)
    .keyboardShortcut("c", modifiers: [.option, .command])
    
    // Dax window
    Window(WindowType.dax.rawValue, id: WindowType.dax.rawValue) {
      DaxView()
        .environment(api)
        .environment(settings)
    }
    .windowResizability(WindowResizability.contentSize)
    .defaultPosition(.topTrailing)
    .keyboardShortcut("d", modifiers: [.option, .command])
    
    // Settings window
    Settings {
      SettingsView()
        .environment(api)
        .environment(settings)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(WindowResizability.contentSize)
    .defaultPosition(.bottomLeading)
    
    .commands {
      //remove the "New" menu item
      CommandGroup(replacing: CommandGroupPlacement.newItem) {}
    }
  }
}

@MainActor func closeAuxiliaryWindows() {
  
  print("----->>>>>", "Closing auxiliary windows")
  for window in NSApplication.shared.windows {
    print("----->>>>>", "Auxiliary window -> " + (window.identifier?.rawValue ?? "nil") + "\n")
    if window.identifier?.rawValue == WindowType.controls.rawValue { window.close() }
    if window.identifier?.rawValue == WindowType.dax.rawValue { window.close() }
    if window.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" { window.close() }
  }
}


