//
//  GazeTrackerState.swift
//  SeeSoDemo
//
//  Created by vc2017mac on 2021/10/05.
//

import Foundation

enum GazeTrackerState {
  case none
  case initializing
  case initialized
  case initFailed
  case startTracking
  case stopTracking
}
