//
//  ContentView.swift
//  SeeSoDemo
//
//  Created by vc2017mac on 2021/10/05.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var manager : SeeSoManager = SeeSoManager.DEFAULT
  @State var statusText : StatusText = .tracker_is_nil
  
  @State var initBtnText : InitButtonText = SeeSoManager.DEFAULT.state == .initialized ? .deinitializing : .initializing
  
  @State var startBtnText : StartText = SeeSoManager.DEFAULT.state == .startTracking ? .stop : .start
  
  @State var disableStartBtn = true
  var body: some View {
    ZStack(){
      VStack(spacing: 50){
        Text(statusText.rawValue)
          .padding()
        VStack(alignment: .trailing, spacing: 16){
          Button(initBtnText.rawValue){
            if initBtnText == .initializing {
              manager.initGazeTracker()
              if manager.state == .initFailed {
                statusText = .tracker_failed_init
                print("error : \(manager.getInitializedError())")
              }else{
                statusText = .tracker_is_init
                initBtnText = .deinitializing
                disableStartBtn = false
                startBtnText = .start
              }
            }else {
              manager.deinitGazeTracker()
              statusText = .tracker_is_nil
              initBtnText = .initializing
              disableStartBtn = true
              startBtnText = .start
            }
          }
          
          Button(startBtnText.rawValue){
            if startBtnText == .start {
              manager.startTracking()
            }else{
              manager.stopTracking()
            }
          }.disabled(disableStartBtn)
        }
      }
    }
    
    Circle() // dynamically sized circle
      .stroke()
      .frame(width: 20, height: 20)
      .overlay(GeometryReader{ geometry in
        Circle() // sized based on first
          .frame(width: geometry.size.width*0.5, height: geometry.size.height*0.5)
      }).position(x: manager.x, y: manager.y).opacity(manager.state == .startTracking ? 1 : 0)
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
