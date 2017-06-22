//
//  TimberScene.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-20.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol InteractiveNode {
    func sceneLoaded()
    func interact()
}

class Timber: SKScene {
    
    var tree = Tree()
    var playerPosition: Int = 0
    var amountCut: Int = 0

    
    override func didMove(to view: SKView) {
        print("hello")
        
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })
        
        playerPosition = -1 // left
        tree.BuildTree(scene: scene!)
        // TODO: Place player next to tree
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveRight), name: Notification.Name(RightTile.rightTapped), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveLeft), name: Notification.Name(LeftTile.leftTapped), object: nil)
    }
    
    func moveRight() {
        if playerPosition == -1 {
            
        }
        
        print("right / test")
    }
    
    func moveLeft() {
        if playerPosition == 1 {
            
        }
        cutTree()
        print("left / test")
    }
    
    
    func cutTree() {
        // CHECK IF PLAYER IS SQUISHED
        
        
        
        
        if (amountCut + 1) != tree.treeSize {
            if let node = childNode(withName: "tree\(amountCut)") {
                node.removeFromParent()
            }
            
            for i in amountCut+1...tree.treeSize-1 {
                
                if let node = childNode(withName: "tree\(i)") as? SKSpriteNode {
                    let x = SKAction.moveTo(y: node.position.y - (node.size.height * 0.9), duration: 0)
                    node.run(x)
                }
            }
            
            
            
            
            tree.treeLayout.remove(at: 0)
            
            amountCut += 1
        } else {
            print("GameOver")
        }
    }
    
    
    
}
