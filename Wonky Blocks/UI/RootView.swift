//
//  RootView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Foundation
import SwiftUI
import GameController

struct RootView: View {
  @EnvironmentObject var gameState: WonkyGameState
  @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
  @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

  @State var showInstructions = true
  
  var keyboardConnected: Bool {
    return GCKeyboard.coalesced != nil
  }

  var body: some View {
    GeometryReader { (size: GeometryProxy) in
      ZStack {
        VStack(spacing: 0) {
          if gameState.gameStarted && size.size.width <= size.size.height && !gameState.gameOver {
            HStack {
              if gameState.gameStarted && showInstructions && keyboardConnected && horizontalSizeClass == .regular {
                InstructionsView(layoutDirection: .horizontal)
              }
              Spacer()
              ScoreBoardView()
              PiecePreviewView(piece: self.gameState.nextTet)
                .frame(maxWidth: 150, maxHeight: 150)
                .padding(10)
            }
          }
          HStack(spacing: 0) {
            if !gameState.gameStarted {
              MainMenuView()
            } else if gameState.gameOver {
              GameOverView()
            } else {
              GameView()
            }
            if size.size.width > size.size.height, gameState.gameStarted, !gameState.gameOver {
              VStack {
                Spacer()
                ScoreBoardView()
                PiecePreviewView(piece: self.gameState.nextTet)
                  .frame(width: 150, height: 150)
                  .padding(10)
                Spacer()
                Group {
                  if showInstructions && keyboardConnected && keyboardConnected && verticalSizeClass == .regular {
                    InstructionsView(layoutDirection: .vertical)
                  }
                }
              }
            }
          }
        }
        // we don't want this to get in the way of button presses
        #if !targetEnvironment(macCatalyst)
          if gameState.gameStarted, !gameState.gameOver {
            VStack {
              Spacer(minLength: size.size.height / 2)  // cause joysticks to only be on bottom half so buttons can be pressed
              HStack(spacing: 0) {
                Joystick(state: $gameState.movementJoyState, radius: 100)
                Joystick(state: $gameState.rotationJoyState, radius: 100)
              }
            }
          }
        #endif
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
          withAnimation(.easeInOut(duration: 1.5)) {
            showInstructions.toggle()
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
