//
//  planetTest.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class PlanetEarth: planetBase {
    
    override func sceneLoaded() {
        name = PlanetList.earth
        isUserInteractionEnabled = true
        hasOil = true
        hasMinerals = true
        hasMetal = true
        planetDesc = SKSpriteNode(imageNamed: "earthDesc")
        descText = PlanetDescriptions.earth
    }
    
    override func interact() {

        if !descOpen {
            GameViewController.Player.currentPlanetSelected = name!
            openPlanetDesc(name: name!)
            NotificationCenter.default.post(Notification(name: NSNotification.Name(PlanetUtils.touched), object: nil))
        }
        
    }
}
