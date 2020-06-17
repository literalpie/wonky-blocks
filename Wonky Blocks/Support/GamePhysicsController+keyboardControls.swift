//
//  GamePhysicsController+keyboardControls.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension GamePhysicsController {
    func handleKeyEvents() {
        if activePiece?.physicsBody?.velocity.dy ?? -100 > -100 {
            activePiece?.physicsBody?.velocity.dy = -100
        }
        if leftPressed, !rightPressed {
            let xVelocity = activePiece?.physicsBody?.velocity.dx
            activePiece?.physicsBody?.velocity.dx = [xVelocity! - 50, CGFloat(-250)].max()!
        }
        if rightPressed, !leftPressed {
            let xVelocity = activePiece?.physicsBody?.velocity.dx
            activePiece?.physicsBody?.velocity.dx = [xVelocity! + 50, CGFloat(250)].min()!
        }
        if downPressed, !upPressed {
            let yVelocity = activePiece?.physicsBody?.velocity.dy
            activePiece?.physicsBody?.velocity.dy = [yVelocity! - 40, CGFloat(-500)].max()!
        }
        if upPressed, !downPressed {
            let yVelocity = activePiece?.physicsBody?.velocity.dy
            activePiece?.physicsBody?.velocity.dy = [yVelocity! + 40, CGFloat(-100)].min()!
        }
        if rightTouchPressed, !leftTouchPressed {
            activePiece?.physicsBody?.angularVelocity = -2.8
        }
        if leftTouchPressed, !rightTouchPressed {
            activePiece?.physicsBody?.angularVelocity = 2.8
        }
        if rotateLeftPressed, !rotateRightPressed {
            let rVelocity = activePiece?.physicsBody?.angularVelocity
            activePiece?.physicsBody?.angularVelocity = [rVelocity! + 0.7, CGFloat(2.8)].min()!
        }
        if rotateRightPressed, !rotateLeftPressed {
            let rVelocity = activePiece?.physicsBody?.angularVelocity
            activePiece?.physicsBody?.angularVelocity = [rVelocity! - 0.7, CGFloat(-2.8)].max()!
        }
    }


    func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {

        if (presses.contains { $0.key?.keyCode == .keyboardLeftArrow }) {
            leftPressed = true
            keyboardUsed = true
        }
        if (presses.contains { $0.key?.keyCode == .keyboardRightArrow }) {
            rightPressed = true
            keyboardUsed = true
        }
        if (presses.contains { $0.key?.keyCode == .keyboardDownArrow }) {
            downPressed = true
            keyboardUsed = true
        }
        if (presses.contains { $0.key?.keyCode == .keyboardUpArrow }){
            upPressed = true
            keyboardUsed = true
        }
        if (presses.contains { $0.key?.keyCode == .keyboardZ }){
            rotateLeftPressed = true
            keyboardUsed = true
        }
        if (presses.contains { $0.key?.keyCode == .keyboardX }){
            rotateRightPressed = true
            keyboardUsed = true
        }
    }

    func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if (presses.contains { $0.key?.keyCode == .keyboardLeftArrow }) {
            leftPressed = false
        }
        if (presses.contains { $0.key?.keyCode == .keyboardRightArrow }) {
            rightPressed = false
        }
        if (presses.contains { $0.key?.keyCode == .keyboardUpArrow }) {
            upPressed = false
        }

        if (presses.contains { $0.key?.keyCode == .keyboardDownArrow }) {
            downPressed = false
        }
        if (presses.contains { $0.key?.keyCode == .keyboardZ }) {
            rotateLeftPressed = false
        }

        if (presses.contains { $0.key?.keyCode == .keyboardX }) {
            rotateRightPressed = false
        }
    }
}
