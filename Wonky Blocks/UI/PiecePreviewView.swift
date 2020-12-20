//
//  PiecePreviewView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SpriteKit
import SwiftUI

struct PiecePreviewView: UIViewRepresentable {
  static let previewSize: CGFloat = 300
  func makeCoordinator() -> Coordinator {
    return Coordinator(view: SKView())
  }
  var piece: WonkyTetronimo

  func makeUIView(context: Context) -> SKView {
    let scene = SKScene(size: CGSize(width: Self.previewSize, height: Self.previewSize))
    let view = context.coordinator.view
    view.presentScene(scene)
    position(piece, in: scene)
    return view
  }

  func updateUIView(_ uiView: SKView, context: Context) {
    let view = context.coordinator.view
    guard let scene = view.scene else { return }
    if view.scene?.children.firstIndex(of: piece) == nil {
      position(piece, in: scene)
    }
  }

  func position(_ piece: WonkyTetronimo, in scene: SKScene) {
    // async makes sure other view is dismantled before we position.
    // /(this is a workaround. A better solution would be better)
    DispatchQueue.main.async {
      guard piece.parent != scene else { return }
      scene.isPaused = false
      piece.removeFromParent()
      scene.addChild(piece)
      piece.position = CGPoint(
        x: Self.previewSize / 2 - piece.center.x,
        y: Self.previewSize / 2 - piece.center.y
      )
      scene.isPaused = true
    }
  }

  static func dismantleUIView(_ uiView: SKView, coordinator: Coordinator) {
    uiView.scene?.children.forEach { $0.removeFromParent() }
  }

  class Coordinator {
    let view: SKView
    init(view: SKView) {
      self.view = view
    }
  }
}

struct PiecePreviewView_Previews: PreviewProvider {
  static var previews: some View {
    PiecePreviewView(piece: WonkyTetronimo(WonkyTetronimo.tetronimoTypes[0]))
      .scaledToFit()
  }
}
