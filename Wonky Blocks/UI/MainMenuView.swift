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
      Text("Wonky Blocks")
        .font(.largeTitle)
        .padding(.bottom, 30)
      // for keyboard shortcut
      if #available(macCatalyst 14.0, iOS 14.0, *) {
        Button("Start Game") {
          if (gameState.gameStarted) {
            // sometimes if you hit enter when the game is first started,
            // it will try to start the game twice.
            return
          }
          gameState.resetGame()
          gameState.gameStarted = true
        }
        .keyboardShortcut(.defaultAction)
        .wonkyButton()
      } else {
        Button("Start Game") {
          gameState.resetGame()
          gameState.gameStarted = true
        }
        .wonkyButton()
        .padding()
      }
      Text("High Score: \(gameState.highScore)")
      Button("Reset High Score") {
        gameState.resetHighScore()
      }
      .wonkyButton()
    }
  }
}

struct WonkyButton: ViewModifier {
  func body(content: Content) -> some View {
    return
      content
      .foregroundColor(.primary)
      .font(.headline)
      .padding(5)
      .border(Color.primary)
  }
}

extension View {
  func wonkyButton() -> some View {
    return self.modifier(WonkyButton())
  }
}

struct MainMenuView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MainMenuView()
        .environmentObject(WonkyGameState())
    }
  }
}
