//
//  planetTest.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class PlanetYellow: planetBase {

    
    override func sceneLoaded() {
        name = PlanetList.yellow
        isUserInteractionEnabled = true
        hasOil = true
        planetDesc = SKSpriteNode(imageNamed: "yellowDesc")
        descText = PlanetDescriptions.yellow
    }
    
    override func interact() {

        if !descOpen {
            GameViewController.Player.currentPlanetSelected = name!
            openPlanetDesc(name: name!)
            
            NotificationCenter.default.post(Notification(name: NSNotification.Name(PlanetUtils.touched), object: nil))
        }
        
    }
}
