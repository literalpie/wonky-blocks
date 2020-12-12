//
//  GamePhysicsController+keyboardControls.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

extension GamePhysicsController {
  func handleKeyEvents() {
    if let activePiece = activePiece,
       let physicsBody = activePiece.physicsBody,
       physicsBody.velocity.dy > -activePiece.minimumVelocity {
      physicsBody.velocity.dy = -activePiece.minimumVelocity
    }
    if leftPressed, !rightPressed {
      activePiece?.moveLeft()
    }
    if rightPressed, !leftPressed {
      activePiece?.moveRight()
    }
    if downPressed, !upPressed {
      activePiece?.moveDown()
    }
    if upPressed, !downPressed {
      activePiece?.moveUp()
    }
    if rotateLeftPressed, !rotateRightPressed {
      activePiece?.rotateLeft()
    }
    if rotateRightPressed, !rotateLeftPressed {
      activePiece?.rotateRight()
    }
  }

  func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {

    if (presses.contains { $0.key?.keyCode == .keyboardLeftArrow }) {
      leftPressed = true
      keyboardUsed = true
    }
    if (presses.contains { $0.key?.keyCode == .keyboardRightArrow }) {
      rightPressed = true
      keyboardUsed = true
    }
    if (presses.contains { $0.key?.keyCode == .keyboardDownArrow }) {
      downPressed = true
      keyboardUsed = true
    }
    if (presses.contains { $0.key?.keyCode == .keyboardUpArrow }) {
      upPressed = true
      keyboardUsed = true
    }
    if (presses.contains { $0.key?.keyCode == .keyboardZ }) {
      rotateLeftPressed = true
      keyboardUsed = true
    }
    if (presses.contains { $0.key?.keyCode == .keyboardX }) {
      rotateRightPressed = true
      keyboardUsed = true
    }
  }

  func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    if (presses.contains { $0.key?.keyCode == .keyboardLeftArrow }) {
      leftPressed = false
    }
    if (presses.contains { $0.key?.keyCode == .keyboardRightArrow }) {
      rightPressed = false
    }
    if (presses.contains { $0.key?.keyCode == .keyboardUpArrow }) {
      upPressed = false
    }

    if (presses.contains { $0.key?.keyCode == .keyboardDownArrow }) {
      downPressed = false
    }
    if (presses.contains { $0.key?.keyCode == .keyboardZ }) {
      rotateLeftPressed = false
    }

    if (presses.contains { $0.key?.keyCode == .keyboardX }) {
      rotateRightPressed = false
    }
  }
}
