//
//  planetTest.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class PlanetRed: planetBase {

    override func sceneLoaded() {
        name = PlanetList.red
        isUserInteractionEnabled = true
        hasMetal = true
        planetDesc = SKSpriteNode(imageNamed: "redDesc")
        descText = PlanetDescriptions.red
    }
    
    override func interact() {
        if !descOpen {
            GameViewController.Player.currentPlanetSelected = name!
            openPlanetDesc(name: name!)
            NotificationCenter.default.post(Notification(name: NSNotification.Name(PlanetUtils.touched), object: nil))
        }
        
    }

}
