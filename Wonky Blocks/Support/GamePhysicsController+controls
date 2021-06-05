//
//  GamePhysicsController+keyboardControls.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import CoreGraphics
import GameController
import Foundation
import UIKit

extension GamePhysicsController {
  func handleKeyEvents() {
    let keyboard = GCKeyboard.coalesced?.keyboardInput

    let upKeyboardPressed = keyboard?.button(forKeyCode: .upArrow)?.isPressed ?? false
    let downKeyboardPressed = keyboard?.button(forKeyCode: .downArrow)?.isPressed ?? false
    let leftKeyboardPressed = keyboard?.button(forKeyCode: .leftArrow)?.isPressed ?? false
    let rightKeyboardPressed = keyboard?.button(forKeyCode: .rightArrow)?.isPressed ?? false
    let rotateRightKeyboardPressed = keyboard?.button(forKeyCode: .keyX)?.isPressed ?? false
    let rotateLeftKeyboardPressed = keyboard?.button(forKeyCode: .keyZ)?.isPressed ?? false

    let upJoystick = joystickState?.movementJoyState.translation.height ?? 0 < -20
    let downJoystick = joystickState?.movementJoyState.translation.height ?? 0 > 20
    let leftJoystick = joystickState?.movementJoyState.translation.width ?? 0 < -20
    let rightJoystick = joystickState?.movementJoyState.translation.width ?? 0 > 20
    let rotateRightJoystick = joystickState?.rotationJoyState.translation.width ?? 0 > 20
    let rotateLeftJoystick = joystickState?.rotationJoyState.translation.width ?? 0 < -20
        
    let upPressed = upKeyboardPressed || upJoystick
    let downPressed = downKeyboardPressed || downJoystick
    let leftPressed = leftKeyboardPressed || leftJoystick
    let rightPressed = rightKeyboardPressed || rightJoystick
    let rotateRightPressed = rotateRightKeyboardPressed || rotateRightJoystick
    let rotateLeftPressed = rotateLeftKeyboardPressed || rotateLeftJoystick
    
    if let activePiece = activePiece,
      let physicsBody = activePiece.physicsBody,
      physicsBody.velocity.dy > -activePiece.minimumVelocity
    {
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
}
