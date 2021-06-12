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
    
    let verticalJoystick = (joystickState?.movementJoyState.translation.height ?? 0) / 100
    let horizontalJoystick = (joystickState?.movementJoyState.translation.width ?? 0) / 100
    let rotateJoystick = (joystickState?.rotationJoyState.translation.width ?? 0) / 100
    let upJoystick = joystickState?.movementJoyState.translation.height ?? 0 < 0
    let downJoystick = joystickState?.movementJoyState.translation.height ?? 0 > 0
    let leftJoystick = joystickState?.movementJoyState.translation.width ?? 0 < 0
    let rightJoystick = joystickState?.movementJoyState.translation.width ?? 0 > 0
    let rotateRightJoystick = joystickState?.rotationJoyState.translation.width ?? 0 > 0
    let rotateLeftJoystick = joystickState?.rotationJoyState.translation.width ?? 0 < 0
    
    var leftControllerPressed: Float = 0
    var rightControllerPressed: Float = 0
    var upControllerPressed: Float = 0
    var downControllerPressed: Float = 0
    var rotateRightControllerPressed: Float = 0
    var rotateLeftControllerPressed: Float = 0

    if let controller = GCController.current?.extendedGamepad {
      leftControllerPressed = max(controller.leftThumbstick.left.value, controller.dpad.left.value)
      rightControllerPressed = max(controller.leftThumbstick.right.value, controller.dpad.right.value)
      upControllerPressed = max(controller.leftThumbstick.up.value, controller.dpad.up.value)
      downControllerPressed = max(controller.leftThumbstick.down.value, controller.dpad.down.value)
      rotateLeftControllerPressed = controller.buttonX.isPressed ? 1 : controller.rightThumbstick.left.value
      rotateRightControllerPressed = controller.buttonA.isPressed ? 1 : controller.rightThumbstick.right.value
    } else if let controller = GCController.current?.microGamepad {
      leftControllerPressed = controller.dpad.left.value
      rightControllerPressed = controller.dpad.right.value
      upControllerPressed = controller.dpad.up.value
      downControllerPressed = controller.dpad.down.value
      rotateLeftControllerPressed = controller.buttonX.isPressed ? 1 : 0
      rotateRightControllerPressed = controller.buttonA.isPressed ? 1 : 0
    }
        
    let upPressed = upKeyboardPressed || upJoystick || upControllerPressed > 0
    let downPressed = downKeyboardPressed || downJoystick || downControllerPressed > 0
    let leftPressed = leftKeyboardPressed || leftJoystick || leftControllerPressed > 0
    let rightPressed = rightKeyboardPressed || rightJoystick || rightControllerPressed > 0
    let rotateRightPressed = rotateRightKeyboardPressed || rotateRightJoystick || rotateRightControllerPressed > 0
    let rotateLeftPressed = rotateLeftKeyboardPressed || rotateLeftJoystick || rotateLeftControllerPressed > 0
    
    if let activePiece = activePiece,
      let physicsBody = activePiece.physicsBody,
      physicsBody.velocity.dy > -activePiece.minimumVelocity
    {
      physicsBody.velocity.dy = -activePiece.minimumVelocity
    }
    if leftPressed, !rightPressed {
      let leftAmount = [leftControllerPressed, Float(horizontalJoystick) * -1].max()!
      activePiece?.moveLeft(withStrength: leftAmount == 0 ? nil : leftAmount)
    }
    if rightPressed, !leftPressed {
      let rightAmount = [rightControllerPressed, Float(horizontalJoystick)].max()!
      activePiece?.moveRight(withStrength: rightAmount == 0 ? nil : rightAmount)
    }
    if downPressed, !upPressed {

      let downAmount = [downControllerPressed, Float(verticalJoystick)].max()!
      activePiece?.moveDown(withStrength: downAmount == 0 ? nil : downAmount)
    }
    if upPressed, !downPressed {
      let upAmount = [upControllerPressed, Float(verticalJoystick) * -1].max()!
      activePiece?.moveUp(withStrength: upAmount == 0 ? nil : upAmount)
    }
    if rotateLeftPressed, !rotateRightPressed {
      let rotateLeftAmount = [rotateLeftControllerPressed, Float(rotateJoystick * -1)].max()!
      activePiece?.rotateLeft(withStrength: rotateLeftAmount == 0 ? nil : rotateLeftAmount)
    }
    if rotateRightPressed, !rotateLeftPressed {
      let rotateRightAmount = [rotateRightControllerPressed, Float(rotateJoystick)].max()!
      activePiece?.rotateRight(withStrength: rotateRightAmount == 0 ? nil : rotateRightAmount)
    }
  }
}
