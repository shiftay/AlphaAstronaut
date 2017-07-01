//
//  BackBtn.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class BackBtn: SKSpriteNode, InteractiveNode {
    
    func interact() {
        print("back")
        
        
        guard let scene = scene else {
            return
        }
        
        let ssButton = scene.camera?.childNode(withName: "ssButton") as? SKSpriteNode
        let stationOL = scene.camera?.childNode(withName: "stationOL") as? SKSpriteNode
        
        stationOL?.run(SKAction.sequence([SKAction.moveTo(x: scene.size.width * 0.5 + (stationOL?.size.width)! * 0.5, duration: 0.5), SKAction.run {
                ssButton?.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
            }]))
    }
    
    
    func sceneLoaded() {
        print("backbutton")
        isUserInteractionEnabled = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        interact()
    }
    
    
}
