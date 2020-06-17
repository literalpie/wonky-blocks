//
//  ScoreboardView.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Foundation
import SwiftUI

struct ScoreBoardView: View {
    @EnvironmentObject var gameState: WonkyGameState

    var body: some View {
        VStack(alignment: .leading) {
            Text("Score: \(gameState.score)")
            Text("Lines Cleared: \(gameState.lineCount)")
            Text("Level: \(gameState.level)")
        }
    }
}

struct ScoreBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoardView().environmentObject(WonkyGameState())
    }
}
