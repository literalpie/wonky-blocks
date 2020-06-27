//
//  PiecePreviewView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SwiftUI
import SpriteKit

struct PiecePreviewView: View {
    var piece: WonkyTetronimo

    // TODO: The scene should probably be created in some sort of state object,
    // not a part of this view struct because we don't want it to get recreated on every input change.
    var spriteScene: SKScene {
        print("create scene")
        let scene = SKScene(size: CGSize(width: 300, height: 300))

        scene.isPaused = false
        scene.addChild(piece)
        piece.position = CGPoint(x: 150 - (piece.center.x), y: 150 - piece.center.y)
        scene.isPaused = true

        return scene
    }
    
    var body: some View {
        SpriteView(scene: self.spriteScene)
    }
}

struct PiecePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PiecePreviewView(piece: WonkyTetronimo(grid: tetronimoShapes[0]))
        .scaledToFit()
    }
}
