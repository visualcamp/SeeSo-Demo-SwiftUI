//
//  SeeSoManager.swift
//  SeeSoDemo
//
//  Created by vc2017mac on 2021/10/05.
//

import Foundation
import SeeSo
import AVFoundation

class SeeSoManager :ObservableObject, InitializationDelegate, GazeDelegate, StatusDelegate{
  public static let DEFAULT : SeeSoManager = SeeSoManager()
  private var tracker : GazeTracker? = nil
  private let licenseKey : String = "Inpu your license key."
  private var errors : InitializationError = .ERROR_NONE
  @Published var state : GazeTrackerState = .none
  @Published var x : Double = .zero
  @Published var y : Double = .zero
  
  func initGazeTracker(){
    if checkAccessCamera() {
      DispatchQueue.main.async {
        self.state = .initializing
      }
      GazeTracker.initGazeTracker(license: licenseKey, delegate: self)
      
    }else{
      requestAccess()
    }
  }
  
  
  public func getInitializedError() -> String {
    errors.description
  }
  
  public func deinitGazeTracker() {
    tracker?.statusDelegate = nil
    GazeTracker.deinitGazeTracker(tracker: tracker)
    tracker = nil
    state = .none
  }
  
  public func startTracking(){
    tracker?.startTracking()
  }
  
  public func stopTracking(){
    tracker?.stopTracking()
  }
  
  private init() {
  
  }
  
  private func requestAccess(){
    AVCaptureDevice.requestAccess(for: AVMediaType.video) {
      response in
      if response {
        self.initGazeTracker()
      }
    }
  }
  
  private func checkAccessCamera() -> Bool {
    return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
  }
  
  
  /* If GazeTracker is nil, the creation failed.
   * At this time, if you look at the InitializationError value, you can see why it failed.
  */
  func onInitialized(tracker: GazeTracker?, error: InitializationError) {
    if tracker != nil {
      self.tracker = tracker
      self.tracker?.gazeDelegate = self
      self.tracker?.statusDelegate = self
      self.state = .initialized
    }else {
      self.errors = error
      self.state = .initFailed
      print(error)
    }
  }
  
  func onStarted() {
    state = .startTracking
    print("start")
  }
  
  func onStopped(error: StatusError) {
    state = .stopTracking
    print("stop")
  }
  
  
  func onGaze(gazeInfo: GazeInfo) {
    if gazeInfo.trackingState == .SUCCESS {
      self.x = gazeInfo.x
      self.y = gazeInfo.y
      
      print("X: \(Int(self.x)) Y : \(Int(self.y))")
    }
  }
  
}
