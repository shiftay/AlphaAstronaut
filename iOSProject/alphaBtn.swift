//
//  alphaBtn.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class alphaBtn: SKSpriteNode, InteractiveNode {
    
    func interact() {
        guard let scene = scene as? World else {
            return
        }
        let alphaSS = scene.childNode(withName: "SpaceStation Alpha") as? SpaceStation
        
        scene.camera?.run(SKAction.sequence([SKAction.move(to: (alphaSS?.position)!, duration: 2.0),
                                             SKAction.run {
                                                World.cameraPos = scene.camera?.position
                                                GameViewController.Player.currentPlanetSelected = "SpaceStation Alpha"
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
