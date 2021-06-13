//
//  Tetronimo.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SpriteKit
import SwiftClipper

class WonkyTetronimo: SKShapeNode {
  static let blockSize = 50
  var center: CGPoint {
    let halfBlockSize = CGFloat(Self.blockSize / 2)
    let originX = children.map { (($0 as? SKShapeNode)?.path?.boundingBox.origin.x)! }
    let originY = children.map { (($0 as? SKShapeNode)?.path?.boundingBox.origin.y)! }
    let midX = (originX.max()! + originX.min()!) / 2
    let midY = (originY.max()! + originY.min()!) / 2
    let center = CGPoint(x: midX + halfBlockSize, y: midY + halfBlockSize)
    return center
  }
  var color: UIColor
  var minimumVelocity: CGFloat = 100
  private var lastPosition: CGPoint?
  var hasMoved = false
  

  static func randomTetronimo() -> WonkyTetronimo {
    return self.init(WonkyTetronimo.tetronimoTypes.randomElement()!)
  }

  /// initialize using a grid of rows and columns indicating whether each position should include a block or be empty
  required init(_ tet: TetronimoType) {
    self.color = tet.color
    super.init()
    var physicsBodies: [SKPhysicsBody] = []
    for col in tet.shape.enumerated() {
      for row in col.element.enumerated() {
        if row.element {
          // width and height are not 50 because SpriteKit adds about 2px of padding around all nodes and we need things to fit flush.
          // unfortunately, this also causes things to "catch" on each other occasionally.
          let path = CGPath(
            rect: CGRect(
              x: row.offset * Self.blockSize,
              y: col.offset * Self.blockSize,
              width: Self.blockSize - 2,
              height: Self.blockSize - 2
            ),
            transform: nil)
          let square = SKShapeNode(path: path)
          square.userData = NSMutableDictionary()
          square.userData?.setValue(
            path.getPathElementsPoints().asClockwise().centroid, forKey: "center")
          square.lineWidth = 1
          square.fillColor = tet.color
          square.strokeColor = .clear
          let physicsBody = SKPhysicsBody(polygonFrom: path)

          physicsBodies.append(physicsBody)
          self.addChild(square)
        }
      }
    }
    self.physicsBody = SKPhysicsBody(bodies: physicsBodies)
    self.setup(color: tet.color)
  }

  /// creates a tetronimo from a collection of paths. Used to create a tetronimo that replaces a piece that's been chopped up by a removed line.
  /// the orignal center point of each path is also saved into the userData of the nodes
  init(
    with childrenPaths: [(path: Path, center: CGPoint)], color: UIColor = currentTheme.randomColor
  ) {
    self.color = color
    super.init()
    let children = childrenPaths.compactMap { (path) -> (SKPhysicsBody, SKShapeNode)? in
      guard let physicsBody = SKPhysicsBody(polygonFrom: path.path.asCgPath()) as SKPhysicsBody?
      else {
        // sometimes physics bodies fail to create from paths - we don't seem to miss any important nodes because of this.
        return nil
      }
      let diffNode = SKShapeNode(path: path.path.asCgPath())
      diffNode.userData = NSMutableDictionary()
      diffNode.userData?.setValue(path.center, forKey: "center")
      diffNode.fillColor = color
      diffNode.lineWidth = 1
      diffNode.strokeColor = .clear
      return (physicsBody, diffNode)
    }
    children.forEach { (physics, node) in
      self.addChild(node)
    }
    self.physicsBody = SKPhysicsBody(bodies: children.map { $0.0 })
    self.setup(color: color)
  }

  private func setup(color: UIColor) {
    physicsBody?.affectedByGravity = false
    physicsBody?.categoryBitMask = tetCategory
    physicsBody?.contactTestBitMask = tetCategory | rowCategory
    physicsBody?.collisionBitMask = groundCategory | tetCategory | wallCategory
    physicsBody?.friction = 0.16
    physicsBody?.linearDamping = 0
    physicsBody?.density = 1
    physicsBody?.restitution = 0.05

    name = "tet"
    fillColor = color
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// The active piece is the one controlled by the user. It needs to not be affected by gravity, have a downward velocity and other things.
  func makeActive(with velocity: CGFloat = 100) {
    minimumVelocity = velocity
    physicsBody?.isDynamic = true
    physicsBody?.affectedByGravity = false
    physicsBody?.velocity = .init(dx: 0, dy: -velocity)
    // higher density so the active piece can push other pieces around.
    physicsBody?.density = 3
    physicsBody?.categoryBitMask = activeTetCategory
    physicsBody?.contactTestBitMask = groundCategory | tetCategory
    physicsBody?.collisionBitMask = groundCategory | tetCategory | wallCategory
    name = "activeTet"
  }

  func makeInactive() {
    name = "tet"
    physicsBody?.affectedByGravity = true
    physicsBody?.categoryBitMask = tetCategory
    physicsBody?.density = 1
  }
  
  func updateHasMoved() {
    if lastPosition == nil {
      hasMoved = true
      lastPosition = self.position
      return
    }
    hasMoved = lastPosition?.distance(to: position) ?? 0 > 0.3
    lastPosition = position
  }
}
