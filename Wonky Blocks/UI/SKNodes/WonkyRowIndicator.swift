//
//  RowIndicator.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SpriteKit

/// The bars on the left side of the board that indicate how full the row is.
class WonkyRowIndicator: SKShapeNode {
  static let indicatorWidth = CGFloat(WonkyRow.rowHeight)  // square, based on the row height
  static let indicatorHeight = CGFloat(WonkyRow.rowHeight)

  override init() {
    super.init()
    self.fillColor = .darkGray
  }

  required init?(coder aDecoder: NSCoder) {
    super.init()
  }

  func updateRowStatus(fillPercentage: CGFloat) {
    let rowStatusWidth = Self.indicatorWidth * fillPercentage
    self.path = CGPath(
      rect: CGRect(x: 0, y: 0, width: rowStatusWidth, height: Self.indicatorHeight),
      transform: nil
    )
    if fillPercentage > 1 {
      self.fillColor = .black
    } else {
      self.fillColor = .darkGray
    }
  }
}
