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
    var treeSize: Int = 50
    let middle = SKSpriteNode(imageNamed: "Tree_Middle")
    
    init() {
        middle.size = CGSize(width: middle.size.width, height: 28)
        middle.setScale(5)
        CreateTree()
    }
    
    func CreateTree() {
        for i in 0...treeSize-1 {
            treeLayout.insert(Int.random(min: -1, max: 1), at: i)
//            treeLayout.append(Int.random(min:-1, max:1))
//            treeLayout[i] = Int.random(min: -1, max: 1)
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
    
    // TODO: 
    //      Set anchor point of left / right branches independantly so they line up.
    
    
    func setLeft(pos: Int, scene: SKScene) {
        let left = SKSpriteNode(imageNamed: "Tree_Left")
        left.name = "tree\(pos)"
        left.size = CGSize(width: left.size.width, height: 28)
        left.setScale(5)
        left.position = CGPoint(x: scene.size.width * 0.5 - left.size.width / 6,
                                y: middle.size.height * 0.5 + ((middle.size.height * 0.9) * CGFloat(pos)))
        scene.addChild(left)
    }
    
    func setMiddle(pos: Int, scene: SKScene) {
        let mid = SKSpriteNode(imageNamed: "Tree_Middle")
        mid.name = "tree\(pos)"
        mid.size = CGSize(width: mid.size.width, height: 28)
        
        mid.setScale(5)
        
        mid.position = CGPoint(x: scene.size.width * 0.5,
                               y: middle.size.height * 0.5 + ((middle.size.height * 0.9) * CGFloat(pos)) )
        scene.addChild(mid)
    }
    
    func setRight(pos: Int, scene: SKScene) {
        let right = SKSpriteNode(imageNamed: "Tree_Right")
        right.name = "tree\(pos)"
        right.size = CGSize(width: right.size.width, height: 28)
        right.setScale(5)
        right.position = CGPoint(x: scene.size.width * 0.5,
                                 y: middle.size.height * 0.5 + ((middle.size.height * 0.9) * CGFloat(pos)))
        scene.addChild(right)
    }
    
    
}
