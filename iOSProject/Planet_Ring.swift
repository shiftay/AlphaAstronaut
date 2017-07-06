//
//  planetTest.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class PlanetRing: planetBase {
    
    override func sceneLoaded() {
        name = PlanetList.ring
        hasMinerals = true
        hasOil = true
        hasMetal = true
        isUserInteractionEnabled = true
        planetDesc = SKSpriteNode(imageNamed: "ringDesc")
        descText = PlanetDescriptions.ring
    }
    
    override func interact() {

        if !descOpen {
            GameViewController.Player.currentPlanetSelected = name!
            openPlanetDesc(name: name!)
            NotificationCenter.default.post(Notification(name: NSNotification.Name(PlanetUtils.touched), object: nil))
        }
    }
}
