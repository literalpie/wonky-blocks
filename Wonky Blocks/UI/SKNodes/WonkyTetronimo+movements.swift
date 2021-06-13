//
//  WonkyTetronimo+movements.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 12/12/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import CoreGraphics
import Foundation

var startLeftTime:UInt64?

extension WonkyTetronimo {
  func moveLeft(withStrength: Float?, multiplier: CGFloat = 1) {
    let xVelocity = self.physicsBody?.velocity.dx
    if xVelocity == 0 {
      startLeftTime = DispatchTime.now().uptimeNanoseconds
    }
    let strength = withStrength != nil ? withStrength! * 1.5 : 1
    self.physicsBody?.velocity.dx = [xVelocity! - (50 * CGFloat(strength) * multiplier), CGFloat(-300)].max()!
    if self.physicsBody?.velocity.dx == -300, let thestartLeftTime = startLeftTime {
      print("total time: \(DispatchTime.now().uptimeNanoseconds - (thestartLeftTime))")
      startLeftTime = nil
    }
  }

  func moveRight(withStrength: Float?, multiplier: CGFloat = 1) {
    let xVelocity = self.physicsBody?.velocity.dx
    let strength = withStrength != nil ? withStrength! * 1.5 : 1
    self.physicsBody?.velocity.dx = [xVelocity! + (50 * CGFloat(strength) * multiplier), CGFloat(300)].min()!
  }

  func moveDown(withStrength: Float?, multiplier: CGFloat = 1) {
    let yVelocity = self.physicsBody?.velocity.dy
    self.physicsBody?.velocity.dy = [yVelocity! - (40 * CGFloat(withStrength ?? 1) * multiplier), CGFloat(-400 - minimumVelocity)].max()!
  }

  func moveUp(withStrength: Float?, multiplier: CGFloat = 1) {
    let yVelocity = self.physicsBody?.velocity.dy
    self.physicsBody?.velocity.dy = [yVelocity! + (40 * CGFloat(withStrength ?? 1) * multiplier), CGFloat(-minimumVelocity)].min()!
  }

  func rotateLeft(withStrength: Float?, multiplier: CGFloat = 1) {
    let rVelocity = self.physicsBody?.angularVelocity
    let strength = withStrength != nil ? withStrength! * 1.5 : 1
    self.physicsBody?.angularVelocity = [rVelocity! + (0.7 * CGFloat(strength) * multiplier), CGFloat(2.8)].min()!
  }

  func rotateRight(withStrength: Float?, multiplier: CGFloat = 1) {
    let rVelocity = self.physicsBody?.angularVelocity
    let strength = withStrength != nil ? withStrength! * 1.5 : 1
    self.physicsBody?.angularVelocity = [rVelocity! - (0.7 * CGFloat(strength) * multiplier), CGFloat(-2.8)].max()!
  }
}
