//
//  TimberScene.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-20.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit


protocol InteractiveNode {
    func sceneLoaded()
    func interact()
}

class Timber: SKScene {

    var test: CustomSlider?
    static let resizeSlider = "Resize"
    var tree = Tree()
    var playerPosition: Int = 0 {
        didSet {
            if playerPosition == -1 {
                playerSprite.position = leftPos
            } else {
                playerSprite.position = rightPos
            }
        }
    }
    var resourcesNeeded: Int = 0
    var amountCut: Int = 0
    var playerSprite = SKSpriteNode(imageNamed: "Spaceship")
    
    var leftPos = CGPoint.zero
    var rightPos = CGPoint.zero
    var playable: Bool = true
    
    override func didMove(to view: SKView) {
        print("hello")
        leftPos = CGPoint(x: size.width * 0.25, y: playerSprite.size.height * 2)
        rightPos = CGPoint(x: size.width * 0.75, y: playerSprite.size.height * 2)

        resourcesNeeded = 50
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })
        
        playerPosition = -1 // left
        addChild(playerSprite)
        tree.BuildTree(scene: scene!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveRight), name: Notification.Name(RightTile.rightTapped), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveLeft), name: Notification.Name(LeftTile.leftTapped), object: nil)
    }
    
    func moveRight() {
        if !playable {
            return
        }

        if playerPosition == -1 {
            // move player object.
            playerPosition = 1
        }
        cutTree()
    }
    
    func moveLeft() {
        if !playable {
            return
        }

        if playerPosition == 1 {
            // move player object.
            playerPosition = -1
        }
        cutTree()
    }
    
    
    func cutTree() {
        if (amountCut + 1) <= resourcesNeeded {
            if let node = childNode(withName: "tree\(amountCut)") {
                node.removeFromParent()
            }
            
            enumerateChildNodes(withName: "//tree*", using: { node, _ in
                if let node = node as? SKSpriteNode {
                    let x = SKAction.moveTo(y: node.position.y - (node.size.height), duration: 0)
                    node.run(x)
                }
            })

            NotificationCenter.default.post(Notification(name: NSNotification.Name(Timber.resizeSlider), object: nil))
            
            tree.treeLayout.remove(at: 0)
            tree.addToEnd()
            updateTree()

            amountCut += 1
            checkGameOver()
            
        } else {
            print("You Win")
            playable = false
        }

    }
    
    func checkGameOver() {
        if tree.treeLayout[0] == playerPosition {
//            playable = false
            print("You Lose")
            // TODO:
            // Player knocked out. Lose X Resources, dark out scene, put overlay to retry
        }
 
    }
    
    func updateTree() {
        switch tree.treeLayout[tree.treeLayout.count - 1] {
        case -1:
            tree.setLeft(pos: tree.treeLayout.count - 1, scene: (scene)!, test: tree.treeLayout.count + (amountCut))
        case 0:
            tree.setMiddle(pos: tree.treeLayout.count - 1, scene: (scene)!, test: tree.treeLayout.count + (amountCut))
        case 1:
            tree.setRight(pos: tree.treeLayout.count - 1, scene: (scene)!, test: tree.treeLayout.count + (amountCut))
        default:
            break
        }
    }
    
}
