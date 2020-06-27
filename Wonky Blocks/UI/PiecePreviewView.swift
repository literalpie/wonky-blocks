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

    @StateObject var spriteScene = WonkyPiecePreviewScene(size: CGSize(width: 300, height: 300))
    
    var body: some View {
        SpriteView(scene: self.spriteScene)
            .onChange(of: piece) { value in
                spriteScene.changePiece(to: value)
            }
    }
}

struct PiecePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PiecePreviewView(piece: WonkyTetronimo(grid: tetronimoShapes[0]))
        .scaledToFit()
    }
}

class WonkyPiecePreviewScene: SKScene, ObservableObject {
    func changePiece(to newPiece: WonkyTetronimo) {
        self.isPaused = false
        self.addChild(newPiece)
        newPiece.position = CGPoint(x: 150 - (newPiece.center.x), y: 150 - newPiece.center.y)
        self.isPaused = true
    }
}
