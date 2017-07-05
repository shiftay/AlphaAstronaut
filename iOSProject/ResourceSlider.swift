//
//  ResourceSlider.swift
//  iOSProject
//
//  Created by Vraj Patel on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class ResourceSlider: SKSpriteNode, InteractiveNode
{
    func sceneLoaded()
    {
        guard let scene = scene as? Runner else
        {
            return
        }
        
        scene.addToCamera(node: self)
        zPosition = 3
        
        if let node = childNode(withName: "Slider") as? SKSpriteNode {
            node.yScale = CGFloat((100 - GameViewController.Player.ShipStock.spaceLeft())) / 10.0
        }      
        
        NotificationCenter.default.addObserver(self, selector: #selector(scaleSlider), name: Notification.Name(Runner.scale), object: nil)
    }
    func scaleSlider()
    {
        if let node = childNode(withName: "Slider") as? SKSpriteNode {
            node.yScale = CGFloat((100 - GameViewController.Player.ShipStock.spaceLeft())) / 10.0
        }
    }
    
    func interact()
    {
    }
}
