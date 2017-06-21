//
//  Left.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-20.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class LeftTile: SKSpriteNode, InteractiveNode {
    static let leftTapped = "tappedLeft"
    
    func sceneLoaded() {
        guard let scene = scene else {
            return
        }
        
        zPosition = -1
        position = CGPoint(x: scene.size.width * 0.25,
                           y: scene.size.height * 0.5)
        size = CGSize(width: scene.size.width * 0.5,
                      height: scene.size.height)
        
        alpha = 0.01
        
        isUserInteractionEnabled = true
    }
    
    func interact() {
        NotificationCenter.default.post(Notification(name: NSNotification.Name(LeftTile.leftTapped), object: nil))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
