//
//  betaBtn.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-07-05.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class betaBtn: SKSpriteNode, InteractiveNode {
    
    func interact() {
        guard let scene = scene as? World else {
            return
        }
        let alphaSS = scene.childNode(withName: SSList.beta) as? SpaceStation
        
        scene.camera?.run(SKAction.sequence([SKAction.move(to: (alphaSS?.position)!, duration: 2.0),
                                             SKAction.run {
                                                World.cameraPos = scene.camera?.position
                                                GameViewController.Player.currentPlanetSelected = SSList.beta
                                                scene.spaceStationTouched = true
                                                alphaSS?.openDesc(name: (alphaSS?.name)!)
            }]))
        
        let ssButton = scene.camera?.childNode(withName: "ssButton") as? SKSpriteNode
        let stationOL = scene.camera?.childNode(withName: "stationOL") as? SKSpriteNode
        
        stationOL?.run(SKAction.sequence([SKAction.moveTo(x: scene.size.width * 0.5 + (stationOL?.size.width)! * 0.5, duration: 0.5),
                                          SKAction.run {
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
