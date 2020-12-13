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
          if gameState.gameStarted && (size.size.width <= size.size.height || gameState.gameOver) {
            HStack {
              ScoreBoardView()
              if !gameState.gameOver {
                PiecePreviewView(piece: self.gameState.nextTet)
                  .frame(maxWidth: 150, maxHeight: 150)
              }
            }
          }
          HStack {
            if !gameState.gameStarted {
              MainMenuView()
            } else if gameState.gameOver {
              GameOverView()
            } else {
              GameView(joyState: self.$joyState, rotateState: self.$rotateState)
            }
            if size.size.width > size.size.height, gameState.gameStarted, !gameState.gameOver {
              VStack {
                ScoreBoardView()
                PiecePreviewView(piece: self.gameState.nextTet)
                  .frame(maxWidth: 150, maxHeight: 150)
              }
            }
          }
        }
        // we don't want this to get in the way of button presses
        if gameState.gameStarted, !gameState.gameOver {
          VStack {
            Spacer(minLength: size.size.height / 2)// cause joysticks to only be on bottom half so buttons can be pressed
            HStack(spacing: 0) {
              Joystick(state: self.$joyState, radius: 50)
              Joystick(state: self.$rotateState, radius: 50)
            }
          }
        }
      }
      .frame(width: size.size.width, height: size.size.height, alignment: .center)
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
