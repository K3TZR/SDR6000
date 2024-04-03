//
//  SDRView.swift
//  Sdr6000
//
//  Created by Douglas Adams on 6/3/23.
//

import AVFoundation
import SwiftUI

//import AudioPopoverFeature
import ClientFeature
import DaxAudioFeature
import FlexApiFeature
import ListenerFeature
import LoginFeature
//import MonitorControl
//import PanafallFeature
import PickerFeature
import RxAudioFeature
import SharedFeature
import XCGLogFeature

// ----------------------------------------------------------------------------
// MARK: - View

struct SDRView: View {

  var body: some View {
      Text("SDR View")

    // ---------- Toolbars ----------
    .toolbar {
      // always shown
      ToolbarItem(placement: .navigation) {
        ToolbarLeft()
      }
      // only shown after connecting
      ToolbarItem() {
        ToolbarRight()
      }
    }
  }
  
}

//struct SdrView: View {
//
//  @State private var loginPassword: String = ""
//  @State private var disconnectHandle: UInt32? = nil
//  @State private var selectedPacket: Packet?
//
//  @Environment(\.openWindow) private var openWindow
//  
//  @Environment(ApiModel.self) private var api
//  @Environment(Listener.self) private var listener
//  @Environment(RxAVAudioPlayer.self) private var rxAVAudioPlayer
//  @Environment(SdrModel.self) private var sdr
//  @Environment(SettingsModel.self) private var settings
//  
//  var body: some View {
//    @Bindable var settingsBindable = settings
//    @Bindable var sdrBindable = sdr
//    
//    VStack {
//      VSplitView {
//        ForEach(api.panadapters) { panadapter in
//          if panadapter.clientHandle == api.connectionHandle {
//            VStack {
//              PanafallView(panadapter: panadapter)
//            }
//          }
//        }
//        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
//      }
//      Divider().frame(height: 2).background(Color.gray)
//      if let meter = api.meterBy(shortName: .voltageAfterFuse) {
//        FooterView(api: api, meter: meter)
//      }
//    }
//    // ---------- Initialization ----------
//    .onAppear {
//      sdr.onAppear()
//      // if the controls were previously open, open them
//      if settings.openControls { openWindow(id: "Controls") }
//
//    }
//    
//    // ---------- Smartlink ENABLED CHANGED ----------
//    .onChange(of: settings.smartlinkEnabled) {
//      sdr.smartlinkMode(enabled: $1)
//    }
//
//    // ---------- Sheets ----------
//    // Alert
//    .alert(isPresented: $sdrBindable.showAlert) {
//      Alert(title: Text(sdr.alertText))
//    }
//    
//    // Client connection sheet
//    .sheet(isPresented: $sdrBindable.showClientSheet, onDismiss: {
//      sdr.clientDismissed(selectedPacket, disconnectHandle)
//    }) {
//      ClientView(packet: $selectedPacket, choice: $disconnectHandle)
//    }
//    
//    // Smartlink Login  sheet
//    .sheet(isPresented: $sdrBindable.showLoginSheet, onDismiss: {
//      sdr.loginDismissed(loginPassword)
//    }) {
//      LoginView(user: $settingsBindable.smartlinkUser, pwd: $loginPassword)
//    }
//
//    // Picker sheet
//    .sheet(isPresented: $sdrBindable.showPickerSheet, onDismiss: {
//      sdr.pickerDismissed(selectedPacket)
//    }) {
//      PickerView(selection: $selectedPacket, defaultMethod: { sdr.setDefault($0) }, testMethod: { sdr.test($0) })
//    }
//    
//    // ---------- Settings Window Observation ----------
//    .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { notification in
//      // observe opening of settings panel
//      if let window = notification.object as? NSWindow {
//        if window.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" {
//          // make it floating
//          window.level = .floating
//        }
//      }
//    }
//  }
//}
//
//// ----------------------------------------------------------------------------
//// MARK: - SubView(s)
//
//private struct FooterView: View {
//  var api: ApiModel
//  var meter: Meter
//  
//  @Environment(Listener.self) private var listener
//  
//  var utc: String {
//    let formatter = DateFormatter()
//    formatter.timeZone = TimeZone(abbreviation: "UTC")
//    return formatter.string(from: Date())
//  }
//  
//  var body: some View {
//    HStack {
//      Spacer()
//      HStack(spacing: 10) {
//        Text(api.activePacket?.nickname ?? "").font(.title2).foregroundColor(.blue)
//        //        Text("(" + (apiModel.activePacket?.guiClients.map({$0.station}).joined(separator: ", ") ?? "") + ")") // FIXME:
//          .font(.title2).foregroundColor(.blue)
//      }
//      Spacer()
//      Text(api.radio?.packet.source.rawValue ?? "")
//        .foregroundColor(api.radio?.packet.source == .smartlink ? .green : .blue)
//        .font(.title2)
//        .frame(width: 200)
//      Spacer()
//      DateTimeView(format: "MM/dd/yyyy hh:mm", zone: "UTC")
//      MonitorView(meter: meter)
//    }.frame(height: 30)
//      .padding(.horizontal)
//  }
//}
//
//private struct DateTimeView: View {
//  let format: String
//  let zone: String
//  
//  @State var dateTime = ""
//  
//  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//  var formatter: DateFormatter {
//    let formatter = DateFormatter()
//    formatter.timeZone = TimeZone(abbreviation: zone)
//    formatter.dateFormat = format
//    return formatter
//  }
//  
//  var body: some View {
//    
//    Text("UTC " + dateTime)
//      .font(.title2)
//      .foregroundColor(.blue)
//      .onReceive(timer) { _ in
//        self.dateTime = formatter.string(from: Date())
//      }
//      .frame(width: 300)
//  }
//}
//
// ----------------------------------------------------------------------------
// MARK: - Toolbars

private struct ToolbarLeft: View {
  
  //  @Environment(ApiModel.self) private var api
  //  @Environment(Listener.self) private var listener
  //  @Environment(SdrModel.self) private var sdr
  //  @Environment(SettingsModel.self) private var settings
  //  @Environment(RxAVAudioPlayer.self) private var rxAVAudioPlayer
  
  // Temp
  @State private var isConnected = false
  @State private var directEnabled = false
  @State private var localEnabled = true
  @State private var smartlinkEnabled = false
  @State private var remoteRxAudioMute = false
  @State private var remoteRxAudioVolume: Double = 0.5
  @State private var showAudioPopover = false
  
  var body: some View {
    
    HStack {
      // Connection initiation
      Button(isConnected ? "Disconnect" : "Connect") {
        print("connectTapped")
      }
      .background(Color(.green).opacity(0.3))
      .cornerRadius(10)
      .frame(width: 100)
      .disabled((!directEnabled && !localEnabled && !smartlinkEnabled) )
      
      // Connection types
      //      if api.radio == nil {
      ControlGroup {
        Toggle(isOn: $directEnabled) {
          Text("Direct") }
        Toggle(isOn: $localEnabled) {
          Text("Local") }
        Toggle(isOn: $smartlinkEnabled) {
          Text("Smartlink") }
      }.controlGroupStyle(.navigation)
        .frame(width: 180)
        .padding(.horizontal, 10)
        .disabled(isConnected)
      //      }
      
      // RxAudio
      Image(systemName: remoteRxAudioMute ? "speaker.slash" : "speaker")
        .font(.system(size: 18, weight: .regular))
        .onTapGesture {
          print("remoteRxAudioMuteTapped")
        }
      Slider(value: $remoteRxAudioVolume, in: 0...1).frame(width: 100)
      Button("Audio") { showAudioPopover.toggle() }
        .popover(isPresented: $showAudioPopover , arrowEdge: .bottom) {
          AudioPopover()
        }
    }
  }
}
  
private struct ToolbarRight: View {
  
//  @Environment(ApiModel.self) private var api
//  @Environment(SettingsModel.self) private var settings

  // Temp
  @State private var tnfsEnabled = false
  @State private var cwxEnabled = false
  @State private var fullDuplexEnabled = false
  @State private var markersEnabled = false

  var body: some View {
    
//    if let radio = api.radio {
      // only shown after connecting
      HStack {
        Button("+Pan") {  print("panButtonTapped") }
        
        Group {
          Toggle("Tnfs", isOn: $tnfsEnabled)
          Toggle("CWX", isOn: $cwxEnabled)
          Toggle("FDX", isOn: $fullDuplexEnabled)
          Spacer()
          Toggle("Markers", isOn: $markersEnabled)
        }.toggleStyle(.button)
      }
//    }
  }
}


//    .onAppear() {
//      // setup left mouse down tracking
//      NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) {
//        if $0.modifierFlags.contains(.option) {
//            isOptionPressed = true
//        } else {
//            isOptionPressed = false
//        }
//        return $0
//      }
//    }
//    
//    .onChange(of: settings.localEnabled) {
//      listener.localMode($1)
//    }
//        
//    // ---------- RxAUDIO ENABLED CHANGED ----------
//    .onChange(of: settings.remoteRxAudioEnabled) {
//      sdr.remoteRxAudio(enabled: $1)
//    }
//
//    // ---------- RxAUDIO DEVICE CHANGED ----------
//    .onChange(of: settings.remoteRxAudioOutputDeviceId) {
//      rxAVAudioPlayer.setOutputDevice(AudioDeviceID($1))
//    }
//
//    // ---------- RxAUDIO VOLUME CHANGED ----------
//    .onChange(of: settings.remoteRxAudioVolume) {
//      rxAVAudioPlayer.volume($1)
//    }
//
//    // ---------- RxAUDIO MUTE CHANGED ----------
//    .onChange(of: settings.remoteRxAudioMute) {
//      rxAVAudioPlayer.mute($1)
//    }
//  }
//}
//
//}
//
//// ----------------------------------------------------------------------------
//// MARK: - Preview
//
//// NOT WORKING for some unknown reason
//
//#Preview {
//  SdrView()
//    .environment(ApiModel.shared)
//    .environment(Listener.shared)
//    .environment(RxAVAudioPlayer.shared)
////    .environment(SdrModel.shared)
//    .environment(SettingsModel.shared)
//}
//
//
//
