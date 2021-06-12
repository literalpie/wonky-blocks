//
//  WonkyTetronimo+movements.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 12/12/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import CoreGraphics
import Foundation

extension WonkyTetronimo {
  func moveLeft(withStrength: Float?) {
    let xVelocity = self.physicsBody?.velocity.dx
    let strength = withStrength != nil ? withStrength! * 1.5 : 1
    self.physicsBody?.velocity.dx = [xVelocity! - (50 * CGFloat(strength)), CGFloat(-300)].max()!
  }

  func moveRight(withStrength: Float?) {
    let xVelocity = self.physicsBody?.velocity.dx
    let strength = withStrength != nil ? withStrength! * 1.5 : 1
    self.physicsBody?.velocity.dx = [xVelocity! + (50 * CGFloat(strength)), CGFloat(300)].min()!
  }

  func moveDown(withStrength: Float?) {
    let yVelocity = self.physicsBody?.velocity.dy
    self.physicsBody?.velocity.dy = [yVelocity! - (40 * CGFloat(withStrength ?? 1)), CGFloat(-400 - minimumVelocity)].max()!
  }

  func moveUp(withStrength: Float?) {
    let yVelocity = self.physicsBody?.velocity.dy
    self.physicsBody?.velocity.dy = [yVelocity! + (40 * CGFloat(withStrength ?? 1)), CGFloat(-minimumVelocity)].min()!
  }

  func rotateLeft(withStrength: Float?) {
    let rVelocity = self.physicsBody?.angularVelocity
    let strength = withStrength != nil ? withStrength! * 1.5 : 1
    self.physicsBody?.angularVelocity = [rVelocity! + (0.7 * CGFloat(strength)), CGFloat(2.8)].min()!
  }

  func rotateRight(withStrength: Float?) {
    let rVelocity = self.physicsBody?.angularVelocity
    let strength = withStrength != nil ? withStrength! * 1.5 : 1
    self.physicsBody?.angularVelocity = [rVelocity! - (0.7 * CGFloat(strength)), CGFloat(-2.8)].max()!
  }
}
