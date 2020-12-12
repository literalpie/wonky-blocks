//
//  GameState.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Combine
import Foundation

class UserDefaultsObject: ObservableObject {
  @Published var highScore = UserDefaults.standard.integer(forKey: "High Score")
  func setHighScore(to newValue: Int) {
    UserDefaults.standard.set(newValue, forKey: "High Score")
    self.highScore = newValue
  }
}

class WonkyGameState: ObservableObject {
  var userDefaults: UserDefaultsObject = UserDefaultsObject()
  @Published var score = 0
  @Published var lineCount = 0
  @Published var level = 1
  @Published var gameOver = false
  @Published var newHighScore = false

  @Published var activeTet: WonkyTetronimo = WonkyTetronimo.randomTetronimo()
  @Published var nextTet: WonkyTetronimo = WonkyTetronimo.randomTetronimo()

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
    nextTet = WonkyTetronimo.randomTetronimo()
  }

  func endGame() {
    let highScore = userDefaults.highScore
    if score > highScore {
      newHighScore = true
      userDefaults.setHighScore(to: score)
    }
    gameOver = true
  }

  func reset() {
    score = 0
    lineCount = 0
    level = 1
    gameOver = false
    newHighScore = false
    activeTet = nextTet
    nextTet = WonkyTetronimo.randomTetronimo()
  }
}
