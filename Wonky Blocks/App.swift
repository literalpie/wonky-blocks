//
//  AppDelegate.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 4/19/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import SwiftUI

@main
struct WonkyBlocks: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(WonkyGameState())
        }
    }
}
