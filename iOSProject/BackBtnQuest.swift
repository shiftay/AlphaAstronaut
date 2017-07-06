//
//  BackBtnQuest.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-07-05.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class BackBtnQ: SKSpriteNode, InteractiveNode {
    
    func interact() {
        guard let scene = scene else {
            return
        }
        
        let ssButton = scene.camera?.childNode(withName: "questButton") as? SKSpriteNode
        let stationOL = scene.camera?.childNode(withName: "questOL") as? SKSpriteNode
        
        stationOL?.run(SKAction.sequence([SKAction.moveTo(x: 0 - (stationOL?.size.width)! * 1.5, duration: 0.5), SKAction.run {
            ssButton?.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
            }]))
    }
    
    
    func sceneLoaded() {
        isUserInteractionEnabled = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        interact()
    }
    
    
}
