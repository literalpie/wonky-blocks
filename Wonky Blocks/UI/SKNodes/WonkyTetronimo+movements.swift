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
  func moveLeft() {
    let xVelocity = self.physicsBody?.velocity.dx
    self.physicsBody?.velocity.dx = [xVelocity! - 50, CGFloat(-300)].max()!
  }

  func moveRight() {
    let xVelocity = self.physicsBody?.velocity.dx
    self.physicsBody?.velocity.dx = [xVelocity! + 50, CGFloat(300)].min()!
  }

  func moveDown() {
    let yVelocity = self.physicsBody?.velocity.dy
    self.physicsBody?.velocity.dy = [yVelocity! - 40, CGFloat(-400 - minimumVelocity)].max()!
  }

  func moveUp() {
    let yVelocity = self.physicsBody?.velocity.dy
    self.physicsBody?.velocity.dy = [yVelocity! + 40, CGFloat(-minimumVelocity)].min()!
  }

  func rotateLeft() {
    let rVelocity = self.physicsBody?.angularVelocity
    self.physicsBody?.angularVelocity = [rVelocity! + 0.7, CGFloat(2.8)].min()!
  }

  func rotateRight() {
    let rVelocity = self.physicsBody?.angularVelocity
    self.physicsBody?.angularVelocity = [rVelocity! - 0.7, CGFloat(-2.8)].max()!
  }
}
