//
//  Runner.swift
//  iOSProject
//
//  Created by Vraj Patel on 2017-06-22.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class Runner: SKScene
{
    let cameraMovePointsPerSec = 200.0
    let cameraNode = SKCameraNode()
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    
    override func didMove(to view: SKView)
    {
        //        let maxAspectRatio: CGFloat = 16.0 / 9.0
        //        let playableHeight = size.width / maxAspectRatio
        //        let playableMargin = (size.height - playableHeight) * 0.5
        //
        //        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        print("hi")
        for _ in 0...1
        {
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint.zero
            background.name = "bg_1"
            addChild(background)
        }
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        if lastUpdateTime > 0
        {
            dt = currentTime - lastUpdateTime
        }
        else
        {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        moveCamera()
    }
    
    func backgroundNode() -> SKSpriteNode
    {
        let bgNode = SKSpriteNode()
        bgNode.anchorPoint = CGPoint.zero
        bgNode.name = "bg_1"
        
        let bg1 = SKSpriteNode(imageNamed: "bg_1")
        bg1.anchorPoint = CGPoint.zero
        bg1.position = CGPoint.zero
        bgNode.addChild(bg1)
        
        let bg2 = SKSpriteNode(imageNamed: "bg_2")
        bg2.anchorPoint = CGPoint.zero
        bg2.position = CGPoint.zero
        bgNode.addChild(bg2)
        
        let bg3 = SKSpriteNode(imageNamed: "bg_3")
        bg3.anchorPoint = CGPoint.zero
        bg3.position = CGPoint.zero
        bgNode.addChild(bg3)
        
        bgNode.size = CGSize(width: bg1.size.width,
                             height: bg1.size.height + bg2.size.height + bg3.size.height)
        
        return bgNode
    }
    
    func moveCamera()
    {
        let backgroundVelocity = CGPoint(x: 0, y: cameraMovePointsPerSec)
        let amountToMove = backgroundVelocity * CGFloat(dt)
        cameraNode.position += amountToMove
        
    }
}
