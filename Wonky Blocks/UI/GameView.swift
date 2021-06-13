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
    uiViewController.spriteKitView.isPaused = gameState.paused
  }

  static func dismantleUIViewController(
    _ uiViewController: WonkyGameViewController, coordinator: ()
  ) {
    uiViewController.allCans.forEach { $0.cancel() }
  }
}
