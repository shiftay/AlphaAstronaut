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
        //TODO: load up a overlay for the planet in question.
        //      overlay can be made as a sprite
        //      the information for each planet/spacestation will be stored within a file like this.
        //      and the overlay will be built using this information.
        if !descOpen {
            GameViewController.Player.currentPlanetSelected = name!
            openPlanetDesc(name: name!)
            NotificationCenter.default.post(Notification(name: NSNotification.Name(PlanetUtils.touched), object: nil))
        }
        
    }

}
