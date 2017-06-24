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
    
//    var sliderDemo: CustomSlider!
    
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
    
    var amountCut: Int = 0
    var playerSprite = SKSpriteNode(imageNamed: "Spaceship")
    
    var leftPos = CGPoint.zero
    var rightPos = CGPoint.zero
    var playable: Bool = true
    
    override func didMove(to view: SKView) {
        print("hello")
        leftPos = CGPoint(x: size.width * 0.25, y: playerSprite.size.height * 2)
        rightPos = CGPoint(x: size.width * 0.75, y: playerSprite.size.height * 2)

        
        
    
        
        
        
        
//        sliderDemo = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
//        sliderDemo = CustomSlider(rect: CGRect(x: 0 + 110,
//                                               y: 0,
//                                               width: 100,
//                                               height: 20))
//        sliderDemo.setThumbImage(nil, for: UIControlState.normal)
//        sliderDemo.thumbTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.01)
//        sliderDemo.minimumTrackTintColor = .red
//        sliderDemo.tintColor = .green
//        sliderDemo.maximumTrackTintColor = .green
//        sliderDemo.isUserInteractionEnabled = false
//        sliderDemo.maximumValue = Float(tree.treeSize) * 2
//        sliderDemo.minimumValue = 1
//            = UIImage(named: "Spaceship")
//        view.addSubview(sliderDemo)
//        
        
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })
        playerPosition = -1 // left
//        playerSprite.position
        addChild(playerSprite)
        

        tree.BuildTree(scene: scene!)
        // TODO: Place player next to tree
        
        
        
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
            
            NotificationCenter.default.post(Notification(name: NSNotification.Name(Timber.resizeSlider), object: nil))
            
            tree.treeLayout.remove(at: 0)
            print("\(playerPosition)")
            amountCut += 1
            
            checkGameOver()
            
        } else {
            print("GameOver")
            playable = false
        }
        
        
        
    }
    
    func checkGameOver() {
        if tree.treeLayout[0] == playerPosition {
            playable = false
            // TODO:
            // Player knocked out. Lose X Resources, dark out scene, rebuild tree.
        }
        
        
    }
    
}
