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
    static let movedCamera = "moved"
    let cameraMovePointsPerSec = 200.0
    let cameraNode = SKCameraNode()
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var playableRect: CGRect!
    let shape = SKShapeNode()
    var cameraRect: CGRect
    {
        let x = cameraNode.position.x - size.width * 0.5
        let y = cameraNode.position.y - size.height * 0.5
        
        return CGRect(
            x: x,
            y: y,
            width: size.width,
            height: size.height)
    }
    
    override func didMove(to view: SKView)
    {
        for i in 0...1
        {
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: 0, y: CGFloat(i) * background.size.height)
            background.name = "bg"
            addChild(background)
        }
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        playableRect = CGRect(x: 0, y: cameraRect.minY, width: size.width, height: size.height)
        //debugDrawPlayableArea()
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(movePlayerLeft), name: Notification.Name(LeftBtn.leftLane), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movePlayerMiddle), name: Notification.Name(MiddleBtn.middleLane), object: nil)

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
        //updateRect()
        //print("cameraPos \(camera?.position)")
        //print("playableRect: \(playableRect)")
    }
    
    func updateRect()
    {
        playableRect = CGRect(x: 0, y: cameraRect.minY, width: size.width, height: size.height)
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
    }
    
    func backgroundNode() -> SKSpriteNode
    {
        let bgNode = SKSpriteNode()
        bgNode.anchorPoint = CGPoint.zero
        bgNode.name = "bg"
        
        let bg2 = SKSpriteNode(imageNamed: "bg_1")
        bg2.anchorPoint = CGPoint.zero
        bg2.position = CGPoint.zero
        bgNode.addChild(bg2)
        
        let bg3 = SKSpriteNode(imageNamed: "bg_2")
        bg3.anchorPoint = CGPoint.zero
        bg3.position = CGPoint(x: 0, y: bg2.size.height)
        bgNode.addChild(bg3)
        print("bg3: \(bg3.size.height)")
        bgNode.size = CGSize(width: bg2.size.width,
                             height: bg2.size.height + bg3.size.height)
        
        return bgNode
    }
    
    func moveCamera()
    {
        let backgroundVelocity = CGPoint(x: 0, y: cameraMovePointsPerSec)
        let amountToMove = backgroundVelocity * CGFloat(dt)
        cameraNode.position += amountToMove
        
        NotificationCenter.default.post(Notification(name: NSNotification.Name(Runner.movedCamera), object: nil))
        
        enumerateChildNodes(withName: "bg")
        { node, _ in
            let background = node as! SKSpriteNode
            
            if background.position.y + background.size.height < self.cameraRect.origin.y
            {
                background.position = CGPoint(x: background.position.x,
                                              y: background.position.y + background.size.height * 2)
            }
        }
    }
    
    func movePlayerLeft()
    {
        print("Moved left")
    }
    
    func movePlayerMiddle()
    {
        print("Moved center")
    }
    
    func movePlayerRight()
    {
        print("Moved right")
    }
    
    func debugDrawPlayableArea()
    {
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        shape.zPosition = 100
        addChild(shape)
    }
}
