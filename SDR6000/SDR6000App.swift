//
//  Sdr6000App.swift
//  Sdr6000
//
//  Created by Douglas Adams on 6/3/23.
//

import ComposableArchitecture
import SwiftUI

import ControlsFeature
//import DaxFeature
import FlexApiFeature
import ListenerFeature
import RxAudioFeature
import SettingsFeature
import SharedFeature
import XCGLogFeature

public enum WindowType: String {
  case controls = "Controls"
  case dax = "Dax"
  case settings = "Settings"
}

// ----------------------------------------------------------------------------
// MARK: - Main

@main
struct SDR6000App: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  var appDelegate
  
  @State var api = ApiModel.shared
//  @State var settings = SettingsModel.shared
//  @State var listener = Listener.shared
//  @State var rxAVAudioPlayer = RxAVAudioPlayer.shared

  var body: some Scene {
    
    // Main window
    WindowGroup() {
      SDRView()

//        .environment(api)
//        .environment(listener)
//        .environment(settings)
//        .environment(SdrModel(api, listener, settings, rxAVAudioPlayer))
//        .environment(rxAVAudioPlayer)
    }
    .windowStyle(.hiddenTitleBar)

    // Controls window
    Window(WindowType.controls.rawValue, id: WindowType.controls.rawValue) {
      ControlsView(store: Store(initialState: ControlsFeature.State()) {
        ControlsFeature()
      })
      .environment(api)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(WindowResizability.contentSize)
    .defaultPosition(.topTrailing)
    .keyboardShortcut("c", modifiers: [.option, .command])
    
//    // Dax window
//    Window(WindowType.dax.rawValue, id: WindowType.dax.rawValue) {
//      DaxView()
//        .environment(api)
//        .environment(settings)
//    }
//    .windowResizability(WindowResizability.contentSize)
//    .defaultPosition(.topTrailing)
//    .keyboardShortcut("d", modifiers: [.option, .command])
//    
    // Settings window
    Settings {
      SettingsView(store: Store(initialState: SettingsCore.State()) {
        SettingsCore()
      })
        .environment(api)
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

// ----------------------------------------------------------------------------
// MARK: - App Delegate

final class AppDelegate: NSObject, NSApplicationDelegate {

  @MainActor func closeAuxiliaryWindows() {
    
    print("----->>>>>", "Closing auxiliary windows")
    for window in NSApplication.shared.windows {
      print("----->>>>>", "Auxiliary window -> " + (window.identifier?.rawValue ?? "nil") + "\n")
      if window.identifier?.rawValue == WindowType.controls.rawValue { window.close() }
      if window.identifier?.rawValue == WindowType.dax.rawValue { window.close() }
      if window.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" { window.close() }
    }
  }

  func applicationDidFinishLaunching(_ notification: Notification) {
    // disable tab view
    NSWindow.allowsAutomaticWindowTabbing = false
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    closeAuxiliaryWindows()
    log("SDR6000: application terminated", .debug, #function, #file, #line)
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    true
  }
}

// ----------------------------------------------------------------------------
// MARK: - Globals

/// Struct to hold a Semantic Version number
public struct Version {
  public var major: Int = 1
  public var minor: Int = 0
  public var build: Int = 0
  
  // can be used directly in packages
  public init(_ versionString: String = "1.0.0") {
    let components = versionString.components(separatedBy: ".")
      major = Int(components[0]) ?? 1
      minor = Int(components[1]) ?? 0
      build = Int(components[2]) ?? 0
  }
  
  // only useful for Apps & Frameworks (which have a Bundle), not Packages
  public init() {
    let versions = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "?"
    let build   = Bundle.main.infoDictionary![kCFBundleVersionKey as String] as? String ?? "?"
    self.init(versions + ".\(build)")
  }
  
  public var string: String { "\(major).\(minor).\(build)" }
}

