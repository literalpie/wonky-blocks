//
//  SupportingStuff.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 4/20/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SwiftClipper
import CoreGraphics

extension SwiftClipper.Path {
    func asCgPath() -> CGPath {
        let path = CGMutablePath()
        if self.count > 0 {
            let point = self[0]
            path.move(to: point)
            self.forEach { (currentPoint) in
                path.addLine(to: currentPoint)
            }
            path.closeSubpath()
        }
        return path
    }
}
