//
//  GamePhysicsController.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Combine
import SpriteKit

class GamePhysicsController: NSObject, SKPhysicsContactDelegate {
  var can: Cancellable?
  var joystickState: JoystickState?

  /// if the keyboard is ever used, joystick movement will be disabled
  var keyboardUsed = false

  var activePiece: WonkyTetronimo?
  var activePieceContact = PassthroughSubject<Void, Never>()

  func didBegin(_ contact: SKPhysicsContact) {
    guard activePiece != nil else { return }
    guard contact.bodyB.node?.name != "row",
      contact.bodyA.node?.name != "row"
    else { return }
    // only bodyB is ever activeTet
    let activeTetContact =
      contact.bodyB.node?.name == "activeTet" || contact.bodyA.node?.name == "activeTet"
    let groundContact = contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground"
    let otherTetContact = contact.bodyA.node?.name == "tet" || contact.bodyB.node?.name == "tet"
    if activeTetContact && (groundContact || otherTetContact) {
      activePieceContact.send()
    }
  }
}
