//
//  SDRModel.swift
//  Sdr6000
//
//  Created by Douglas Adams on 11/3/23.
//

//import AVFoundation
//import Foundation
//import SwiftUI
//
//import FlexApiFeature
//import ListenerFeature
//import DaxAudioFeature
//import RxAudioFeature
//import SharedFeature
////import SettingsModel
//import XCGLogFeature
//
//@Observable
//@MainActor
//final public class SDRModel {
//  // ----------------------------------------------------------------------------
//  // MARK: - Initialization
//  
//  public init(_ api: ApiModel, _ listener: Listener, _ settings: SettingsModel, _ rxAVAudioPlayer: RxAVAudioPlayer) {
//    _api = api
//    _listener = listener
//    _settings = settings
//    _rxAVAudioPlayer = rxAVAudioPlayer
//  }
//  
//  // ----------------------------------------------------------------------------
//  // MARK: - Public properties
//  
//  public var alertText = "Alert"
//  public var showAlert = false
//  
//  public var showClientSheet = false
//  public var showLoginSheet = false
//  public var showPickerSheet = false
//  
////  public var selectedPacket: Packet?
////  public var clientChoice: UInt32?
////  public var loginPassword: String = ""
//  public var connectionStatus: ConnectionStatus = .disconnected
//  
//  // ----------------------------------------------------------------------------
//  // MARK: - Private properties
//  
//  private var _initialized = false
//  
//  private var _api: ApiModel
//  private var _listener: Listener
//  private var _rxAVAudioPlayer: RxAVAudioPlayer
//  private var _settings: SettingsModel
//  
//  // ----------------------------------------------------------------------------
//  // MARK: - Public methods
//  
//  public func checkConnectionStatus(_ packet: Packet) {
//    // Gui connection with othe stations?
//    if _settings.isGui && packet.guiClients.count > 0 {
//      // show the client chooser, let the user choose
//      showClientSheet = true
//    }
//    else {
//      // not Gui connection or Gui without other stations, attempt to connect
//      connect(packet, nil)
//    }
//  }
//  
//  public func clientDismissed(_ selectedPacket: Packet?, _ disconnectHandle: UInt32?) {
//    //    print("----->>>>> Client dismissed, choice = \(choice?.hex ?? "nil")")
//    if selectedPacket == nil && disconnectHandle == nil {
//      connectionStatus = .disconnected
//    } else if let selectedPacket {
//      connect(selectedPacket, disconnectHandle)
//    }
//  }
//  
//  public func connect(_ packet: Packet, _ disconnectHandle: UInt32?) {
//    Task {
//      // attempt to connect to the selected Radio / Station
//      do {
//        // try to connect
//        try await _api.connect(packet: packet,
//                               isGui: _settings.isGui,
//                               disconnectHandle: disconnectHandle)
//        connectionStatus = .connected
//        if _settings.remoteRxAudioEnabled { remoteRxAudio(enabled: true) }
//        
//      } catch {
//        // connection attempt failed
//        //                await send(.showErrorAlert( error as! ApiError ))
//        connectionStatus = .disconnected
//      }
//    }
//  }
//  
//  public func connectDisconnect(_ isOptionPressed: Bool) {
//    if connectionStatus != .disconnected {
//      connectionStatus = .inProcess
//      // ----- STOP -----
//      if _settings.remoteRxAudioEnabled { remoteRxAudio(enabled: false) }
//      
//      _api.disconnect()
//      connectionStatus = .disconnected
//      
//    } else if connectionStatus == .disconnected {
//      // ----- START -----
//      connectionStatus = .inProcess
//      
//      // use the default?
//      if !isOptionPressed && _settings.useDefault {
//        // YES, use the Default
//        
//        if let packet = _listener.findPacket(for: _settings.guiDefault, _settings.nonGuiDefault, _settings.isGui) {
//          // valid default
////          selectedPacket = packet
//          checkConnectionStatus(packet)
//        } else {
//          // invalid default
//          showPickerSheet = true
//        }
//      } else {
//        // default not in use, open the Picker
//        showPickerSheet = true
//      }
//    }
//  }
//
//  public func loginDismissed(_ loginPassword: String) {
//    if !_settings.smartlinkUser.isEmpty && !loginPassword.isEmpty {
//      Task {
//        if await _listener.startWan(_settings.smartlinkUser, loginPassword) {
//          // SUCCESS,
//          _settings.loginRequired = false
//        } else {
//          _settings.smartlinkEnabled = false
//          // FAILURE, tell the user it failed
//          alertText = "Smartlink login failed for \(_settings.smartlinkUser)"
//          showAlert = true
//        }
//      }
//    } else {
//      _settings.smartlinkEnabled = false
//    }
//  }
//
//  public func onAppear() {
//    // if the first time, start various effects
//    if _initialized == false {
//      _initialized = true
//      
//      // instantiate the Logger,
//      _ = XCGWrapper(logLevel: .debug, group: SettingsModel.FlexSuite)
//      _settings.isGui = true
//      // start / stop listeners as appropriate for the Mode
//      // set the connection mode, start the Lan and/or Wan listener
//      _listener.localMode(_settings.localEnabled)
//      
//      Task {
//        if await !_listener.smartlinkMode(_settings.smartlinkEnabled , _settings.smartlinkUser, _settings.loginRequired) {
//          showLoginSheet = true
//        }
//      }
//    }
//  }
//
//  public func pickerDismissed(_ selectedPacket: Packet?) {
//    if selectedPacket == nil {
//      // cancelled
//      connectionStatus = .disconnected
//      
//    } else {
//      // save the station (if any)
//      //            state.station = selection.station
//      // check for other connections
//      checkConnectionStatus(selectedPacket!)
//    }
//  }
//  
//  public func remoteRxAudio(enabled: Bool) {
//    if enabled {
//      Task {
//        let deviceId = AudioDeviceID(SettingsModel.shared.remoteRxAudioOutputDeviceId)
//        let volume = SettingsModel.shared.remoteRxAudioVolume
//        let isCompressed = SettingsModel.shared.remoteRxAudioCompressed
//        
//        // request a stream
//        if let streamId = try await _api.requestRemoteRxAudioStream(isCompressed: isCompressed).streamId {       // FIXME: use the setting
//          // start player
//          _rxAVAudioPlayer.setup(outputDeviceID: deviceId, volume: volume, isCompressed: isCompressed)   // FIXNE: Where does volume come from?
//          // finish audio setup
//          _rxAVAudioPlayer.start(streamId)
//          _api.remoteRxAudioStreams[id: streamId]?.delegate = _rxAVAudioPlayer
//        } else {
//          // FAILURE, tell the user it failed
//          alertText = "Failed to start a RemoteRxAudioStream"
//          showAlert = true
//        }
//      }
//
//    } else {      
//      _rxAVAudioPlayer.stop()
//      // remove player and stream
//      _api.sendRemoveStream(_rxAVAudioPlayer.streamId)
//    }
//  }
//
//  public func setDefault(_ selectedPacket: Packet) {
//    let newDefault = SettingsModel.DefaultConnection(selectedPacket.serial, selectedPacket.source.rawValue, "")
//    let currentDefault = _settings.guiDefault
//    if currentDefault == nil || currentDefault != newDefault {
//      // no current default or current is not newDefault
//      _settings.guiDefault = newDefault
//      _settings.useDefault = true
//      
//      // close Picker and attempt to connect
//      showPickerSheet = false
//      checkConnectionStatus(selectedPacket)
//      
//    } else if currentDefault == newDefault {
//      // clear current default
//      _settings.guiDefault = nil
//      _settings.useDefault = false
//    }
//  }
//
//  public func smartlinkMode(enabled: Bool) {
//    Task {
//      if await !_listener.smartlinkMode(enabled , _settings.smartlinkUser, _settings.loginRequired) {
//        showLoginSheet = true
//      }
//    }
//  }
//  
//  public func test(_ selectedPacket: Packet) -> Bool {
//    false  // FIXME
//  }
//  
//}
