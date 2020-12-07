//
//  RootView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Foundation
import SwiftUI

struct RootView: View {
  @EnvironmentObject var gameState: WonkyGameState
  @State var joyState: JoyState = .inactive
  @State var rotateState: JoyState = .inactive

  var body: some View {
    GeometryReader { (size: GeometryProxy) in
      ZStack {
        VStack {
          if size.size.width <= size.size.height || gameState.gameOver {
            HStack {
              ScoreBoardView()
              if !gameState.gameOver {
                PiecePreviewView(piece: self.gameState.nextTet)
                  .frame(maxWidth: 150, maxHeight: 150)
              }
            }
          }
          HStack {
            if gameState.gameOver {
              VStack {
                Text("Game Over").font(.title)
                if gameState.newHighScore {
                  Text("New High Score: \(gameState.score)")
                }
                Button("Restart Game", action: self.gameState.reset)
              }
            } else {
              GameView(joyState: self.$joyState, rotateState: self.$rotateState)
            }
            if size.size.width > size.size.height && !gameState.gameOver {
              VStack {
                ScoreBoardView()
                PiecePreviewView(piece: self.gameState.nextTet)
                  .frame(maxWidth: 150, maxHeight: 150)

              }
            }
          }
        }
        // we don't want this to get in the way of button presses
        if !gameState.gameOver {
          HStack(spacing: 0) {
            Joystick(state: self.$joyState, radius: 50)
            Joystick(state: self.$rotateState, radius: 50)
          }
        }
      }
      .background(Color(UIColor.systemBackground))
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RootView()
        .environmentObject(WonkyGameState())
        .previewLayout(.fixed(width: 500, height: 700))
      RootView()
        .environmentObject(WonkyGameState())
        .previewLayout(.fixed(width: 700, height: 500))
        .colorScheme(.dark)
    }

  }
}
