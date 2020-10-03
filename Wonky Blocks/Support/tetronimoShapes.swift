//
//  tetronimoShapes.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Foundation
import UIKit

typealias TetronimoType = (shape: [[Bool]], color: UIColor)

extension WonkyTetronimo {
    static let tetronimoTypes = [
        // I
        (
            shape: [[true], [true], [true], [true]],
            color: currentTheme.colorPalette[0]
        ),
        // S
        (
            shape: [
                [false, true, true],
                [true, true, false],
            ],
            color: currentTheme.colorPalette[1]
        ),
        // Z
        (
            shape: [
                [true, true, false],
                [false, true, true],
            ],
            color: currentTheme.colorPalette[2]
        ),
        // O
        (
            shape: [
                [true, true],
                [true, true]
            ], color: currentTheme.colorPalette[3]
        ),
        // L
        (
            shape: [
                [true, false],
                [true, false],
                [true, true]
            ],
            color: currentTheme.colorPalette[4]
        )
    ]
}
