//
//  World.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

class World: SKScene {
    var background: SKSpriteNode!
    var cameraNode: SKCameraNode?
    var test: Bool = true
    
    
    override func didMove(to view: SKView) {
        print("WorldView")
        guard let scene = scene else {
            return
        }
        
        
        
        
        cameraNode = childNode(withName: "camera") as? SKCameraNode
        background = SKSpriteNode(color: .black, size: scene.size)
        
        addChild(background)
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(setbool), name: Notification.Name(Planet.touched), object: nil)
    }
    
    func setbool() {
        test = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            if test {
                // TODO:    Setup camera boundaries.
                //          Decide how large the solar system is.
                
                print("\(GameViewController.Player.name)")
                
                cameraNode?.run(SKAction.move(to: touch.location(in: self), duration: 0.5))
            }
        }
    }
}
