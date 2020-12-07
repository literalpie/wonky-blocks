//
//  UIColor+Hex.swift
//  Wonky Blocks
//
//  Created by Ashley Si on 2/10/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
    let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
    let blue = CGFloat(hex & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
