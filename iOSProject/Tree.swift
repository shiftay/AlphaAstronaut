//
//  Tree.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-20.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import SpriteKit

class Tree {
    var treeLayout: [Int] = []
    var treeSize: Int = 15
    let middle = SKSpriteNode(imageNamed: "middle")
    
    init() {
        CreateTree()
    }
    
    func CreateTree() {
        for i in 0...treeSize-1 {
            if i <= 4 {
               treeLayout.insert(0, at: i)
            } else {
                switch treeLayout[i - 1] {
                case -1:
                    treeLayout.insert(Int.random(min: -1, max: 0), at: i)
                case 0:
                    treeLayout.insert(Int.random(min: -1, max: 1), at: i)
                case 1:
                    treeLayout.insert(Int.random(min: 0, max: 1), at: i)
                default:
                    break
                }
            }
        }
    }
  
    func BuildTree(scene: SKScene) {
        for i in 0...treeSize-1 {
            switch treeLayout[i] {
            case -1:
                setLeft(pos: i, scene: scene)
            case 0:
                setMiddle(pos: i, scene: scene)
            case 1:
                setRight(pos: i, scene: scene)
            default:
                break
            }

        }
    }
    
    func setLeft(pos: Int, scene: SKScene, test: Int = 0) {
        let left = SKSpriteNode(imageNamed: "left")
        
        if test == 0 {
            left.name = "tree\(pos)"
        } else {
            left.name = "tree\(test)"
        }

        left.anchorPoint = CGPoint(x: 0.62, y: 0.5)
        left.position = CGPoint(x: scene.size.width * 0.5,
                                y: middle.size.height * 0.5 + ((middle.size.height) * CGFloat(pos)))
        scene.addChild(left)
    }
    
    func setMiddle(pos: Int, scene: SKScene, test: Int = 0) {
        let mid = SKSpriteNode(imageNamed: "middle")
        
        if test == 0 {
            mid.name = "tree\(pos)"
        } else {
            mid.name = "tree\(test)"
        }
        
        mid.position = CGPoint(x: scene.size.width * 0.5,
                               y: middle.size.height * 0.5 + ((middle.size.height) * CGFloat(pos)) )
        scene.addChild(mid)
    }
    
    func setRight(pos: Int, scene: SKScene, test: Int = 0) {
        let right = SKSpriteNode(imageNamed: "right")
        
        if test == 0 {
            right.name = "tree\(pos)"
        } else {
            right.name = "tree\(test)"
        }
        
        right.anchorPoint = CGPoint(x: 0.385, y: 0.5)
        right.position = CGPoint(x: scene.size.width * 0.5,
                                 y: middle.size.height * 0.5 + ((middle.size.height) * CGFloat(pos)))
        scene.addChild(right)
    }
    
    func addToEnd() {
        switch treeLayout[treeLayout.count - 1] {
        case -1:
            treeLayout.append(Int.random(min: -1, max: 0))
        case 0:
            treeLayout.append(Int.random(min: -1, max: 1))
        case 1:
            treeLayout.append(Int.random(min: 0, max: 1))
        default:
            break
        }
    }
}
