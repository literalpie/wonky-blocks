//
//  extensions.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SpriteKit
import SwiftClipper

extension CGPath {
    func rotateAroundCenter(path: CGPath, float: CGFloat) -> CGPath? {
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: float)
        return path.copy(using: &transform)
    }
}

extension SKNode {
    // Gets the paths of all children, positioned based on the nodes position
    var childrenPositionPaths: [(path: CGPath, center: CGPoint)] {
        return self.children.compactMap{ child in
            if let childPath = (child as? SKShapeNode)?.path,
               let center = child.userData?.value(forKey: "center") as? CGPoint,
                let transformedPath = childPath.rotateAroundCenter(path: childPath, float: self.zRotation) {
                var translateTransform = CGAffineTransform(translationX: self.position.x, y: self.position.y)

                return ((path: transformedPath.copy(using: &translateTransform), center: center) as! (path: CGPath, center: CGPoint))
            } else {
                return nil
            }
        }
    }
}

extension SwiftClipper.Path {
    func asClockwise() -> SwiftClipper.Path {
        var sum: CGFloat = 0
        for i in 0..<self.count {
            let thisPoint = self[i]
            let previousPoint = i==0 ? self.last! : self[i-1]
            sum += (thisPoint.x - previousPoint.x) * (thisPoint.y + previousPoint.y)
        }
        return sum > 0 ? self : self.reversed()
    }
}

extension Array where Element: Hashable {
    // return the array, filtering out any duplicates so there is only one of each value.
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
