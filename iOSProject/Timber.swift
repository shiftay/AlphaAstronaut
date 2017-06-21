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
    
    
    
    override func didMove(to view: SKView) {
        print("hello")
    
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })
        
        playerPosition = -1 // left
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
        
        print("left / test")
    }
    

    
    
}
