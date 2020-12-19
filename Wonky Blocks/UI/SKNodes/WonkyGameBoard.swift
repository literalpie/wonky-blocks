//
//  GameBoardNode.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Combine
import SpriteKit

class WonkyGameBoard: SKNode {
  static let height = 800
  static let width = 530

  override init() {
    super.init()

    let leftWall = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 1, height: Self.height))
    let rightWall = SKShapeNode(rect: CGRect(x: Self.width, y: 0, width: 1, height: Self.height))
    leftWall.physicsBody = SKPhysicsBody(
      edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: Self.height))
    rightWall.physicsBody = SKPhysicsBody(
      edgeFrom: CGPoint(x: Self.width, y: 0), to: CGPoint(x: Self.width, y: Self.height))
    leftWall.physicsBody?.categoryBitMask = wallCategory
    rightWall.physicsBody?.categoryBitMask = wallCategory
    [leftWall, rightWall].forEach { $0.physicsBody?.categoryBitMask = wallCategory }

    let ground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: Self.width, height: 0))
    ground.name = "ground"
    ground.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -2), to: CGPoint(x: Self.width, y: -2))
    ground.physicsBody?.categoryBitMask = groundCategory

    self.addChild(leftWall)
    self.addChild(rightWall)
    self.addChild(ground)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
