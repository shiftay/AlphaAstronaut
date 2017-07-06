//
//  QuestButton.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-07-05.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class QuestBtn: SKSpriteNode, InteractiveNode {
    var descOpen: Bool = false
    
    func interact() {
        guard let scene = scene as? World else {
            return
        }
        if scene.planetTouched || scene.spaceStationTouched {
            return
        }
        
        if let stationOL = scene.camera?.childNode(withName: "questOL") as? SKSpriteNode {
            
            stationOL.run(SKAction.moveTo(x: 0 - stationOL.size.width * 0.5, duration: 0.5))
            let node = stationOL.childNode(withName: "quest") as? SKLabelNode
            node?.fontName = "Arial"
            node?.fontColor = .white
            node?.fontSize = 25
            if GameViewController.Player.currentQuest != nil {
                node?.text = GameViewController.Player.currentQuest.questName
            } else {
                node?.text = "No active quest"
            }
            
            alpha = 0.0
        }
    }
    
    func sceneLoaded() {
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !descOpen {
            interact()
        }
    }
    
}
