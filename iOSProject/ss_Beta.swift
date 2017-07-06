//
//  ss_Beta.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-07-05.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class SSBeta: SpaceStation {
    
    override func interact() {
        if !descOpen {
            guard let scene = scene as? World else {
                return
            }
            
            scene.spaceStationTouched = true
            openDesc(name: name!)
            GameViewController.Player.currentPlanetSelected = name!
        }
    }
    
    override func sceneLoaded() {
        name = SSList.beta
        isUserInteractionEnabled = true
        ssDesc = SKSpriteNode(imageNamed: "betaDesc")
        descText = SSDesc.beta
        randomizeRates()
        randomizeSell()
        quests.insert(Quest(questGiver: self.name!), at: 0)
        quests.insert(Quest(questGiver: self.name!), at: 1)
    }
    
}
