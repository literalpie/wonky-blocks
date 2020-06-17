//
//  RowIndicatorSpace.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SpriteKit

/// The bar full of row indicators that show how full each row is.
class WonkyRowIndicatorSpace: SKNode {
    var indicators: [WonkyRowIndicator] = []
    override init() {
        super.init()

        for row in 0...14 {
            let rowIndicator = WonkyRowIndicator()
            rowIndicator.position.y = CGFloat(50 * row)
            indicators.append(rowIndicator)
            self.addChild(rowIndicator)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
    }

    func updateAllRowIndicators(rowStates: [CGFloat]) {
        self.indicators.enumerated().forEach { (arg0) in
            let (rowIndex, rowIndicator) = arg0
            rowIndicator.updateRowStatus(fillPercentage: rowStates[rowIndex])
        }
    }
}
