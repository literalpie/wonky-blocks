//
//  GameViewController.swift
//  Wonky Blocks
//
//  Created by Benjamin Kindle on 6/14/20.
//  Copyright © 2020 Benjamin Kindle. All rights reserved.
//

import Combine
import SpriteKit
import SwiftClipper
import UIKit
import GameController

class WonkyGameViewController: UIViewController, SKSceneDelegate {
  static let rowFilledThreshold: CGFloat = 16000

  var spriteKitView: SKView {
    return self.view as! SKView
  }
  let physicsController = GamePhysicsController()
  let rowIndicatorSpace = WonkyRowIndicatorSpace()
  var gameState = WonkyGameState()

  /// collection of all cancellables so we can easily unsubscribe from them all
  var allCans: [Cancellable] = []

  var rows: [WonkyRow] = []

  var minimumSpeed: CGFloat {
    return [CGFloat(100 + self.gameState.level * 20), CGFloat(340)].min()!
  }
  private var lastUpdateTime = TimeInterval()

  deinit {
    spriteKitView.scene?.isPaused = true
    spriteKitView.presentScene(nil)
    allCans.forEach { $0.cancel() }
  }
  
  func update(_ currentTime: TimeInterval, for scene: SKScene) {
    if lastUpdateTime == 0 {
      lastUpdateTime = currentTime
    }
    let delta = currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    if !gameState.paused {
      physicsController.handleKeyEvents(delta: CGFloat(delta))
    }
  }

  override func viewDidLoad() {
    let view = SKView()
    let sceneWidth = WonkyGameBoard.width + Int(WonkyRowIndicator.indicatorWidth)
    let scene = SKScene(size: CGSize(width: sceneWidth, height: WonkyGameBoard.height))
    scene.scaleMode = .aspectFit
    scene.delegate = self

    self.rows = Array(0...15).map { (offset) in
      WonkyRow(rowNumber: offset)
    }
    rows.forEach { $0.position = CGPoint(x: WonkyRowIndicator.indicatorWidth, y: 0) }
    let gameBoard = WonkyGameBoard()
    gameBoard.position = CGPoint(x: WonkyRowIndicator.indicatorWidth, y: 0)
    scene.addChild(gameBoard)
    scene.addChild(rowIndicatorSpace)
    view.presentScene(scene)
    view.scene?.physicsWorld.contactDelegate = self.physicsController
    self.view = view
    self.rows.forEach { self.spriteKitView.scene?.addChild($0) }
    view.ignoresSiblingOrder = true

    // update row indicators (this block doesn't remove any rows)
    let timerCan = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect().sink { (_) in
      if !self.gameState.paused {
        self.checkForMovedTetronimos()
        DispatchQueue.global(qos: .background).async {
          // gets the percentage that each row is filled compared to the target required to clear a row
          let rowStates = self.rows.map { $0.calculateRowArea() / Self.rowFilledThreshold }
          DispatchQueue.main.async {
            self.rowIndicatorSpace.updateAllRowIndicators(rowStates: rowStates)
          }
        }
      }
    }
    allCans.append(timerCan)

    // Remove any rows that are full
    let contactCan = physicsController.activePieceContact.sink { _ in
      guard let activeTet = self.spriteKitView.scene?.childNode(withName: "activeTet") else {
        return
      }
      // if the last piece is at too high a position when contact is made, end the game
      guard self.spriteKitView.scene?.childNode(withName: "activeTet")?.position.y ?? 0 <= 750
      else {
        self.physicsController.activePiece?.makeInactive()
        self.gameState.endGame()
        return
      }
      /// tetromonimos that intesect with a row we are removing
      var breakageCandidates: [SKNode] = []
      /// the index of each row that is above the line-clearing threshold
      var removingRows: [Int] = []
      /// how full each row is
      var rowStates: [CGFloat] = []
      self.rows.enumerated().forEach { row in
        let area = row.element.calculateRowArea()
        rowStates.append(area / Self.rowFilledThreshold)
        if area > Self.rowFilledThreshold {
          let newCandidates = row.element.physicsBody!.allContactedBodies().compactMap { $0.node }
          breakageCandidates.append(contentsOf: newCandidates)
          removingRows.append(row.offset)
        }
      }
      /// uncomment to clear debug line every time contact is made
      //            let debugLine = 0
      //            removingRows = [debugLine]
      //            breakageCandidates = self.rows[debugLine].physicsBody!.allContactedBodies().compactMap{$0.node}
      self.rowIndicatorSpace.updateAllRowIndicators(rowStates: rowStates)
      breakageCandidates = breakageCandidates.uniques
      if !removingRows.isEmpty {
        let removingRowData = self.getSequentialNumbers(in: removingRows)
        let removingRowShapes = self.rowShapes(from: removingRowData)
        removingRowShapes.forEach { (rowToRemove) in
          let (newNodes, oldNodes) = self.remove(
            intersectingNodes: breakageCandidates, fromRow: rowToRemove)
          oldNodes.forEach { nodeToRemove in
            nodeToRemove.removeFromParent()
            breakageCandidates.removeAll { (removeConsideration) -> Bool in
              return removeConsideration == nodeToRemove
            }
          }
          newNodes.forEach { nodeToAdd in
            self.spriteKitView.scene?.addChild(nodeToAdd)
          }
          breakageCandidates.append(contentsOf: newNodes)
        }
        activeTet.physicsBody?.velocity = .zero
      }
      self.gameState.linesCleared(removingRows.count)
      self.gameState.setNextActivePiece()
    }
    allCans.append(contactCan)
    let activeTetCan = self.gameState.$activeTet.sink { (newActive) in
      print("new active")
      let newPieceXPosition =
        (CGFloat(WonkyGameBoard.width) / 2) + WonkyRowIndicator.indicatorWidth - newActive.center.x
      newActive.position = CGPoint(x: newPieceXPosition, y: CGFloat(WonkyGameBoard.height))
      newActive.removeFromParent()  // removes from preview scene
      self.spriteKitView.scene?.addChild(newActive)
      newActive.makeActive(with: self.minimumSpeed)
      self.physicsController.activePiece = newActive
    }
    allCans.append(activeTetCan)
  }
  
  func checkForMovedTetronimos() {
    self.spriteKitView.scene?.children.compactMap({ node in
      return node as? WonkyTetronimo
    }).forEach({ tet in
      tet.updateHasMoved()
    })
  }

  /// given the starting index and span of sets of rows, returns a shape representing the shape and size of the combined rows.
  func rowShapes(from spans: [(rowOffset: Int, rowCount: Int)]) -> [SKShapeNode] {
    let nodes = spans.map { row -> SKShapeNode in
      let nodeCenter = CGPoint(
        x: 250,
        y: row.rowOffset * 50 + (row.rowCount * 50 / 2)
      )
      let node = SKShapeNode(rectOf: CGSize(width: 800, height: 50 * row.rowCount))
      node.position = nodeCenter
      return node
    }
    return nodes
  }
  
  override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
    if (presses.contains { $0.key?.keyCode == .keyboardReturnOrEnter }) {
      self.gameState.paused.toggle()
      lastUpdateTime = TimeInterval()
    }
    let actionKeys: [UIKeyboardHIDUsage] = [
      .keyboardReturnOrEnter,
      .keyboardZ,
      .keyboardX,
      .keyboardLeftArrow,
      .keyboardRightArrow,
      .keyboardUpArrow,
      .keyboardDownArrow,
    ]
    // let the system handle keys that aren't used by the game
    if !(presses.contains { actionKeys.contains($0.key?.keyCode ?? .keyboard0) }) {
      super.pressesBegan(presses, with: event)
    }
  }

  /// given a set of row numbers, returns the index where each set of matching numbers starts, and the number of rows that it spans.
  func getSequentialNumbers(in numbersArray: [Int]) -> [(rowOffset: Int, rowCount: Int)] {
    var rowInfo: [(rowOffset: Int, rowCount: Int)] = []
    for removingRow in numbersArray.enumerated() {
      let lastRowValue = removingRow.offset == 0 ? -1 : numbersArray[removingRow.offset - 1]
      if removingRow.offset == 0 || removingRow.element != lastRowValue + 1 {
        // if it's the first row, or not part of the same group as the last row, add an element to the result that spans one row.
        rowInfo.append((removingRow.element, 1))
      } else {
        // This element is part of the same group as the last entry, so add one to the 'span' of the last entry
        rowInfo[rowInfo.count - 1] = (
          rowOffset: rowInfo.last?.rowOffset ?? 0, rowCount: (rowInfo.last?.rowCount ?? 0) + 1
        )
      }
    }
    return rowInfo
  }

  func remove(intersectingNodes: [SKNode], fromRow: SKShapeNode) -> (
    resultNodes: [SKNode], breakingNodes: [SKNode]
  ) {
    var resultNodes: [SKNode] = []
    var breakingNodes: [SKNode] = []
    let contactingBodies = intersectingNodes
    contactingBodies.forEach({ (intersectingNode) in
      // This will go through each of the bodies that intersects the row being removed.
      // collect the paths that will make up the piece above and below the removed row.
      var belowPaths: [(path: Path, center: CGPoint)] = []
      var abovePaths: [(path: Path, center: CGPoint)] = []

      // One square of the tetronimo
      intersectingNode.childrenPositionPaths.forEach { intChildPath in

        // to calculate difference, we need the location of the row, which isn't included in the path.
        var rowTranslateTransform = CGAffineTransform(
          translationX: fromRow.position.x, y: fromRow.position.y)
        let transformedRowPath = fromRow.path?.copy(using: &rowTranslateTransform)

        let difference = intChildPath.path.getPathElementsPoints().difference(
          (transformedRowPath!.getPathElementsPoints()))
        difference.forEach({ (differencePiece) in
          // Area only seems to be accurate when the points of the path are clockwise.
          // If the remaining are of the piece is very small (less than 50 area), we will remove it completely.
          if differencePiece.asClockwise().area > 50 || differencePiece.asClockwise().area < -50 {
            if differencePiece.first!.y > fromRow.position.y {
              abovePaths.append((differencePiece, intChildPath.center))
            } else {
              belowPaths.append((differencePiece, intChildPath.center))
            }
          }
        })
      }
      let color = (intersectingNode as? WonkyTetronimo)?.color ?? .white
      if !abovePaths.isEmpty {
        let fragments = groupFragments(from: abovePaths)
        fragments.forEach { (fragment) in
          let newNode = WonkyTetronimo(with: fragment, color: color)
          resultNodes.append(newNode)
          newNode.physicsBody?.affectedByGravity = true
        }
      }
      if !belowPaths.isEmpty {
        let fragments = groupFragments(from: belowPaths)
        fragments.forEach { (fragment) in
          let newNode = WonkyTetronimo(with: fragment, color: color)
          resultNodes.append(newNode)
          newNode.physicsBody?.affectedByGravity = true
        }
      }
      breakingNodes.append(intersectingNode)
    })
    return (resultNodes, breakingNodes)
  }

  /// given some shape paths, return the same paths with touching shapes grouped together.
  func groupFragments(from paths: [(path: SwiftClipper.Path, center: CGPoint)]) -> [[(
    path: SwiftClipper.Path, center: CGPoint
  )]] {
    /// each element is a group of paths, and the node's original center (used to determine connection)
    var allPathGroups: [[(path: SwiftClipper.Path, center: CGPoint)]] = []
    paths.forEach { path in
      let touchingPieces = allPathGroups.enumerated().filter { existingPath in
        return existingPath.element.first { existingPathPiece in

          let distance = path.center.distance(to: existingPathPiece.center)
          // in all my testing, the distance between the center of 2
          // connected blocks is always within 60
          return distance < 60
        } != nil
      }
      if touchingPieces.count > 1 {
        // Some pieces were previously put in separate groups, but this new path connects them.
        if touchingPieces.count > 2 {
          print("warning, more than 2 touching pieces, but only 2 will be merged")
        }
        let pieceToMerge = allPathGroups.remove(at: touchingPieces[1].offset)
        allPathGroups[touchingPieces[0].offset].append(contentsOf: pieceToMerge)
        allPathGroups[touchingPieces[0].offset].append(path)
      } else if let touchingPiece = touchingPieces.first?.offset {
        // path is touching a path within touchingPiece, so add it to the same piece.
        allPathGroups[touchingPiece].append(path)
      } else {
        // path isn't touching any of the existing pieces, so make a new one with this new path.
        allPathGroups.append([path])
      }
    }
    return allPathGroups
  }
}
