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
  @Binding var joyState: JoyState
  @Binding var rotateState: JoyState

  func makeUIViewController(context: Context) -> WonkyGameViewController {
    let controller = WonkyGameViewController()
    controller.gameState = self.gameState
    return controller
  }

  func updateUIViewController(
    _ uiViewController: WonkyGameViewController,
    context: Context
  ) {
    if !uiViewController.physicsController.keyboardUsed {
      uiViewController.physicsController.leftPressed = joyState.translation.width < -20
      uiViewController.physicsController.rightPressed = joyState.translation.width > 20
      uiViewController.physicsController.downPressed = joyState.translation.height > 20
      uiViewController.physicsController.upPressed = joyState.translation.height < -20
      uiViewController.physicsController.rotateLeftPressed = rotateState.translation.width < -20
      uiViewController.physicsController.rotateRightPressed = rotateState.translation.width > 20
    }
  }

  static func dismantleUIViewController(
    _ uiViewController: WonkyGameViewController, coordinator: ()
  ) {
    uiViewController.allCans.forEach { $0.cancel() }
    uiViewController.physicsController.can?.cancel()
  }
}
