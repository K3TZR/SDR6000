//
//  Sdr6000Core.swift
//  Sdr6000
//
//  Created by Douglas Adams on 6/3/23.
//

//import ComposableArchitecture
//import SwiftUI
//
//import ClientSheet
//import FlexApi
//import Listener
//import LoginSheet
//import OpusPlayer
//import PickerSheet
//import SettingsModel
//import SharedModel
//import XCGWrapper
//
//
//public enum ConnectionStatus {
//  case disconnected
//  case inProcess
//  case connected
//}
//
//
//public struct Sdr6000: Reducer {
//    
//  private var _settingsModel = SettingsModel.shared
//  private var _listener = Listener.shared
//  
//  @Environment(\.openWindow) private var openWindow
//  
//  // ----------------------------------------------------------------------------
//  // MARK: - Module Initialization
//  
//  public init() { }
//  
//  // ----------------------------------------------------------------------------
//  // MARK: - State
//  
//  public struct State: Equatable {
//    // other state
//    var commandToSend = ""
//    var isClosing = false
//    var gotoLast = false
//    var initialized = false
//    
//    var connectionStatus: ConnectionStatus = .disconnected
//    
//    var opusPlayer: OpusPlayer?
//    var pickables = IdentifiedArrayOf<Pickable>()
//    var station: String? = nil
//    
//    // subview state
//    var alertState: AlertState<Sdr6000.Action>?
////    var clientState: Bool = false
////    var loginState: Bool = false
//    var pickerSelection: UUID? = nil
//    
//    var showClientSheet = false
//    var showPickerSheet = false
//    
//    var previousCommand = ""
//    var commandsIndex = 0
//    var commandsArray = [""]
//    
//    // ----------------------------------------------------------------------------
//    // MARK: - State Initialization
//    
//    public init() {}
//  }
//  
//  // ----------------------------------------------------------------------------
//  // MARK: - Actions
//  public enum Action: Equatable {
//    // initialization
////    case onAppear(Listener)
//    
//    // UI controls
////    case ConnectDisconnect
//    case cwxButton(Bool)
//    case directButton(Bool)
//    case fdxButton(Bool)
//    case headphoneGain(Int)
//    case headphoneMute(Bool)
//    case lineoutGain(Int)
//    case lineoutMute(Bool)
////    case localButton(Bool)
//    case markerButton(Bool)
//    case panadapterButton
//    case panelButton
//    case rxButton(Bool)
//    case smartlinkButton(Bool)
//    case stationName(String)
//    case tnfButton(Bool)
//    case txButton(Bool)
//
//    // Subview related
//    case alertDismissed
////    case clientDismissed
////    case loginDismissed
//    case pickerDismissed(Packet?)
//    
//    // Effects related
//    case connect(Packet, UInt32?)
//    case connectionStatus(ConnectionStatus)
//    case loginStatus(Bool, String)
//    
//    // Sheet related
//    case showClientSheet(Packet, [String], [UInt32])
//    case showErrorAlert(ApiError)
//    case showLogAlert(LogEntry)
////    case showLoginSheet
//    case showPickerSheet
//    
//    // Subscription related
//    case clientEvent(ClientEvent)
//    case testResult(TestResult)
//  }
//  
//  public var body: some Reducer<State, Action> {
//    Reduce { state, action in
//      switch action {
//        // ----------------------------------------------------------------------------
//        // MARK: - Actions: SdrView Initialization
//        
////      case let .onAppear(listener):
////        // if the first time, start various effects
////        if state.initialized == false {
////          state.initialized = true
////          // instantiate the Logger,
////          _ = XCGWrapper(logLevel: .debug, group: DefaultValues.flexSuite)
////          _settingsModel.isGui = true
////          // start subscriptions
////          return .merge(
////            subscribeToClients(listener),
////            subscribeToLogAlerts(),
////            subscribeToTestResults(listener),
////            initializeMode(state, listener, _settingsModel)
////          )
////        }
////        return .none
////        
//        // ----------------------------------------------------------------------------
//        // MARK: - Actions: invoked by other actions
//        
//
//      case let .showErrorAlert(error):
//        state.alertState = AlertState(title: TextState("An Error occurred"), message: TextState(error.rawValue))
//        return .none
//        
//
//        // ----------------------------------------------------------------------------
//        // MARK: - Actions: invoked by subscriptions
//        
//      case let .clientEvent(event):
//        // a GuiClient change occurred
//        switch event.action {
//        case .added:
//          return .none
//          
//        case .removed:
//          return .run {[isGui = _settingsModel.isGui, station = state.station] _ in
//            // if nonGui, is it our connected Station?
//            if isGui == false && event.client.station == station {
//              // YES, unbind
//              await ApiModel.shared.setActiveStation( nil )
//              await ApiModel.shared.bindToGuiClient(nil)
//            }
//          }
//          
//        case .completed:
//          return .run { [isGui = _settingsModel.isGui, station = state.station] _ in
//            // if nonGui, is there a clientId for our connected Station?
//            if isGui == false && event.client.station == station {
//              // YES, bind to it
//              await ApiModel.shared.setActiveStation( event.client.station )
//              await ApiModel.shared.bindToGuiClient(UUID(uuidString: event.client.clientId!))
//            }
//          }
//        }
//        
//      case let .showLogAlert(logEntry):
//        if _settingsModel.alertOnError {
//          // a Warning or Error has been logged, exit any sheet states
////          state.clientState = nil
////          state.loginState = nil
////          state.pickerState = nil
//          // alert the user
//          state.alertState = .init(title: TextState("\(logEntry.level == .warning ? "A Warning" : "An Error") was logged:"),
//                                   message: TextState(logEntry.msg))
//        }
//        return .none
//        
//      case let .testResult(result):
//        // a test result has been received
////        state.pickerState?.testResult = result.success
//        return .none
//        
//        // ----------------------------------------------------------------------------
//        // MARK: - Alert Actions
//        
//      case .alertDismissed:
//        state.alertState = nil
//        return .none
//
//
//private func closeWindow(id: String) {
//  print("Close \(id)")
//}
//
//// ----------------------------------------------------------------------------
//// MARK: - Subscription methods
//
//private func subscribeToClients(_ listener: Listener) ->  Effect<Sdr6000.Action> {
//  return .run { send in
//    for await event in listener.clientStream {
//      // a guiClient has been added / updated or deleted
//      await send(.clientEvent(event))
//    }
//  }
//}
//
//private func subscribeToLogAlerts() ->  Effect<Sdr6000.Action>  {
//  return .run { send in
//    for await entry in logAlerts {
//      // a Warning or Error has been logged.
//      await send(.showLogAlert(entry))
//    }
//  }
//}
//
//private func subscribeToTestResults(_ listener: Listener) ->  Effect<Sdr6000.Action>  {
//  return .run { send in
//    for await result in listener.testStream{
//      // a Smartlink test result was received
//      await send(.testResult(result))
//    }
//  }
//}
