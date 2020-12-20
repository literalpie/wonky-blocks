//
//  Row.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SpriteKit

/// A row of the board. The area that must be filled to remove a line, and the area where the line will be removed
class WonkyRow: SKShapeNode {
  static let rowWidth = 550
  static let rowHeight = 50

  init(rowNumber: Int = 0) {
    super.init()
    let rowSize = CGSize(width: Self.rowWidth, height: Self.rowHeight)
    let rowCenter = CGPoint(
      x: rowSize.width / 2, y: rowSize.height / 2 + (CGFloat(Self.rowHeight * rowNumber)))
    self.path = CGPath(
      rect: CGRect(
        x: 0, y: Self.rowHeight * rowNumber, width: Self.rowWidth, height: Self.rowHeight
      ),
      transform: nil
    )
    physicsBody = SKPhysicsBody(
      rectangleOf: rowSize, center: CGPoint(x: rowCenter.x, y: rowCenter.y))
    physicsBody?.affectedByGravity = true
    physicsBody?.isDynamic = false
    physicsBody?.contactTestBitMask = tetCategory | activeTetCategory
    physicsBody?.categoryBitMask = rowCategory
    self.name = "row"
    self.fillColor = rowNumber % 2 > 0 ? UIColor(white: 1, alpha: 0.05) : .clear
    strokeColor = .clear
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func calculateRowArea() -> CGFloat {
    let contactingBodies = self.physicsBody?.allContactedBodies()
    let uniqueBodies = contactingBodies?.uniques
    let totalArea = uniqueBodies!.reduce(
      0,
      { (soFar, current) -> CGFloat in
        // take the sum of the area of the intersection between every piece and the row.
        var totalArea = soFar
        current.node?.childrenPositionPaths.forEach { childNodePath in
          let intersect = self.path?.getPathElementsPoints().intersection(
            childNodePath.path.getPathElementsPoints())
          intersect?.forEach({ (path) in
            totalArea += -path.asClockwise().area
          })
        }
        return totalArea
      })
    return totalArea
  }
}
