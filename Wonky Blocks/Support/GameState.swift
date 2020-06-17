//
//  GameState.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Combine

class WonkyGameState: ObservableObject {
    @Published var score = 0
    @Published var lineCount = 0
    @Published var level = 1

    @Published var activeTet: WonkyTetronimo = WonkyTetronimo(grid: tetronimoShapes.randomElement()!)
    @Published var nextTet: WonkyTetronimo = WonkyTetronimo(grid: tetronimoShapes.randomElement()!)

    func linesCleared(_ lineCount: Int) {
        self.lineCount += lineCount
        let newPoints: Int
        // award more points if more lines are cleared at once.
        switch lineCount {
        case 0:
            newPoints = 0
        case 1:
            newPoints = 40
        case 2:
            newPoints = 100
        case 3:
            newPoints = 300
        case 4:
            newPoints = 1200
        case 5:
            newPoints = 2400
        case 6:
            newPoints = 4800
        default:
            newPoints = 9600
        }
        score += newPoints * (level)
        level = self.lineCount / 10 + 1
    }

    func setNextActivePiece() {
        activeTet.makeInactive()
        nextTet.removeFromParent()
        activeTet = nextTet
        activeTet.makeActive()
        nextTet = WonkyTetronimo(grid: tetronimoShapes.randomElement()!)
    }
}
