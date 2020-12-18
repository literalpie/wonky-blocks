//
//  InstructionsView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 12/16/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SwiftUI

enum LayoutDirection {
  case horizontal
  case vertical
}

struct InstructionsView: View {
  var layoutDirection: LayoutDirection = .horizontal

  var body: some View {
    if layoutDirection == LayoutDirection.vertical {
      VStack {
        HStack {
          rotationInstructions
        }
        .padding()
        HStack {
          movementInstructions
        }
        .padding()
      }
    } else {
      HStack {
        HStack {
          rotationInstructions
        }
        .padding()
        HStack {
          movementInstructions
        }
        .padding()
      }
    }
  }

  var rotationInstructions: some View {
    Group {
      KeyHintView(
        keyHint: KeyHint(keyName: "Z", actionImage: "arrow.counterclockwise")
      )
      KeyHintView(
        keyHint: KeyHint(keyName: "X", actionImage: "arrow.clockwise")
      )
    }
  }

  var movementInstructions: some View {
    Group {
      KeyHintView(
        keyHint: KeyHint(keyName: "←", actionImage: "arrow.left")
      )
      KeyHintView(
        keyHint: KeyHint(keyName: "→", actionImage: "arrow.right")
      )
    }
  }
}

struct KeyHintView: View {
  var keyHint: KeyHint

  var body: some View {
    VStack {
      Rectangle().frame(width: 50, height: 50)
        .cornerRadius(10.0)
        .foregroundColor(.black)
        .overlay(Text(keyHint.keyName))
        .foregroundColor(.white)
        .padding(.bottom, 10)
      Image(systemName: keyHint.actionImage)
        .font(.title)
    }
  }
}

struct KeyHint {
  var keyName: String
  var actionImage: String
}

struct InstructionsView_Previews: PreviewProvider {
  static var previews: some View {
    InstructionsView()
      .previewLayout(.sizeThatFits)
  }
}
