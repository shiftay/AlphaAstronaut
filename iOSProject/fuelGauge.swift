//
//  fuelGauge.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-07-02.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class FuelGauge: SKSpriteNode, InteractiveNode {
    
    func interact() {}
    
    func sceneLoaded() {
        name = "FuelGauge"
        xScale = CGFloat(GameViewController.Player.ShipStock.currentFuel) / 10
        NotificationCenter.default.addObserver(self, selector: #selector(setGauge), name: Notification.Name(World.updateGauge), object: nil)
    }
    
    func setGauge() {
        xScale = CGFloat(GameViewController.Player.ShipStock.currentFuel) / 10
    }
}
