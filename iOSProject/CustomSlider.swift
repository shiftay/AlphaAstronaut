//
//  UISlider.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-23.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class CustomSlider: SKSpriteNode, InteractiveNode {
    
    var currentSize: Int = 1
    var maxSize: CGFloat = 0

    func interact() {
        return
    }
    
    func sceneLoaded() {
        guard let scene = scene else {
            return
        }

        size = CGSize(width: 5, height: 30)
        position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height - size.height)
        zPosition = 100
//        anchorPoint = CGPoint(x: 0,y: 0.5)

         NotificationCenter.default.addObserver(self, selector: #selector(resize), name: Notification.Name(Timber.resizeSlider), object: nil)
    }
    
    func resize() {
        if maxSize == 0 {
            maxSize = 5
        }
        
        currentSize += 2

        // TODO: Add Animations?
        
        xScale = CGFloat(currentSize)
    }
}
