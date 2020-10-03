//
//  PiecePreviewView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SwiftUI
import SpriteKit

struct PiecePreviewView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(view: SKView())
    }
    var piece: WonkyTetronimo

    func makeUIView(context: Context) -> SKView {
        let scene = SKScene(size: CGSize(width: 300, height: 300))
        let view = context.coordinator.view
        view.presentScene(scene)
        position(piece, in: scene)
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        let view = context.coordinator.view
        guard let scene = view.scene else {return}
        if view.scene?.children.firstIndex(of: piece) == nil {
            position(piece, in: scene)
        }
    }
    
    func position(_ piece: WonkyTetronimo, in scene: SKScene) {
        scene.isPaused = false
        piece.removeFromParent()
        scene.addChild(piece)
        piece.position = CGPoint(x: 150 - (piece.center.x), y: 150 - piece.center.y)
        scene.isPaused = true
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
