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
        
    }
    
    func interact()
    {
    }
}
