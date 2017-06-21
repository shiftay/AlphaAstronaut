//
//  RightTile.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-20.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class RightTile: SKSpriteNode, InteractiveNode {
    static let rightTapped = "tappedRight"
    
    func sceneLoaded() {
        guard let scene = scene else {
            return
        }
        
        zPosition = -1
        position = CGPoint(x: scene.size.width * 0.75,
                           y: scene.size.height * 0.5)
        size = CGSize(width: scene.size.width * 0.5,
                      height: scene.size.height)
        
        isUserInteractionEnabled = true
        alpha = 0.01
    }
    
    func interact() {
        NotificationCenter.default.post(Notification(name: NSNotification.Name(RightTile.rightTapped), object: nil))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
