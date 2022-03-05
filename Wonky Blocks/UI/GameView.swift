//
//  GameView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SwiftUI

struct GameView: UIViewControllerRepresentable {
  @EnvironmentObject var gameState: WonkyGameState

  func makeUIViewController(context: Context) -> WonkyGameViewController {
    let controller = WonkyGameViewController()
    controller.gameState = self.gameState
    controller.physicsController.joystickState = gameState
    return controller
  }

  func updateUIViewController(
    _ uiViewController: WonkyGameViewController,
    context: Context
  ) {
    // pausing the scene causes a delay when unpausing. We'll stop the phyiscs instead to avoid this.
    // unfortunately, this means there will be consistent CPU usage while the app is running.
    // I tried pausing only when the window is inactive,
    //but macOS only counts as inactive when you minimize - and spritekit already pauses when this happens.
    uiViewController.spriteKitView.scene?.physicsWorld.speed = gameState.paused ? 0.0 : 1.0
  }

  static func dismantleUIViewController(
    _ uiViewController: WonkyGameViewController, coordinator: ()
  ) {
    uiViewController.allCans.forEach { $0.cancel() }
  }
}
