//
//  MainMenuView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 12/13/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SwiftUI

struct MainMenuView: View {
  @EnvironmentObject var gameState: WonkyGameState
  
  var body: some View {
    VStack {
      Text("Wonky Blocks!")
      Text("High Score: \(gameState.highScore)")
      Button("Start Game") {
        gameState.resetGame()
        gameState.gameStarted = true
      }
      Button("Reset High Score") {
        gameState.resetHighScore()
      }
    }
  }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
