//
//  GameOverView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 12/13/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SwiftUI

struct GameOverView: View {
  @EnvironmentObject var gameState: WonkyGameState

  var body: some View {
    VStack {
      Text("Game Over").font(.largeTitle)
      ScoreBoardView()
      if gameState.newHighScore {
        Text("New High Score: \(gameState.score)")
          .padding()
      }
      Button("Restart Game", action: self.gameState.resetGame)
        .wonkyButton()
      Button("Main Menu") {
        gameState.gameStarted = false
        gameState.gameOver = false
      }
      .wonkyButton()
    }
  }
}

struct GameOverView_Previews: PreviewProvider {
  static var previews: some View {
    GameOverView()
      .environmentObject(WonkyGameState())
  }
}
