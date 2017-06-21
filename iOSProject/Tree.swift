//
//  Tree.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-20.
//  Copyright © 2017 See No Evil. All rights reserved.
//

class Tree {
    var treeLayout: [Int] = []
    var treeSize: Int = 50
    
    init() {
        CreateTree()
    }
    
    func CreateTree() {
        for i in 0...treeSize-1 {
            treeLayout.insert(Int.random(min: -1, max: 1), at: i)
//            treeLayout.append(Int.random(min:-1, max:1))
//            treeLayout[i] = Int.random(min: -1, max: 1)
        }
    }
}
