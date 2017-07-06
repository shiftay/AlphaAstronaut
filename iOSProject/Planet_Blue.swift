//
//  Planet_Blue.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-27.
//  Copyright © 2017 See No Evil. All rights reserved.
//
import Foundation
import SpriteKit

class PlanetBlue: planetBase {

    override func sceneLoaded() {
        name = PlanetList.blue
        hasMinerals = true
        isUserInteractionEnabled = true
        planetDesc = SKSpriteNode(imageNamed: "blueDesc")
        descText = PlanetDescriptions.blue
    }
    
    override func interact() {
        if !descOpen {
            GameViewController.Player.currentPlanetSelected = name!
            openPlanetDesc(name: name!)
            NotificationCenter.default.post(Notification(name: NSNotification.Name(PlanetUtils.touched), object: nil))
        }
        
    }
}
