//
//  ColorTheme.swift
//  Wonky Blocks
//
//  Created by Ashley Si on 2/10/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import UIKit

// TODO: add menu to change color theme
var currentTheme: ColorTheme = .pastel

enum ColorTheme {
    case rainbow, pastel, goodOldBlue
    
    var randomColor: UIColor {
        return self.colorPalette.randomElement()!
    }
    
    var colorPalette: [UIColor] {
        switch self {
        case .rainbow:
            return [
              .red,
              .orange,
              .yellow,
              .green,
              .blue,
              .cyan,
              .purple,
            ]
        case .pastel:
            return [
              UIColor(hex: 0xffd5e5),
              UIColor(hex: 0xffffdd),
              UIColor(hex: 0xa0ffe6),
              UIColor(hex: 0x81f5ff),
              UIColor(hex: 0xc295d8),
              UIColor(hex: 0xffd3b6),
            ]
        case .goodOldBlue:
            return [.blue]
        }
    }
}
