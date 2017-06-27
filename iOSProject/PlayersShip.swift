//
//  PlayersShip.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class PlayersShip {
    let name = "Player"
    let image = SKSpriteNode(imageNamed: "Spaceship")
    var ShipStock: ShipUtilities!
//    var ShipRoster
    var currentPosition: CGPoint!
    var currentMoney: Int
    var currentReputation: Int
    var currentQuest: Quest!
    var currentPlanetSelected: String = "none"
    
    init() {
        ShipStock = ShipUtilities(maxFuel: 100, maxHullSpace: 500, maxShields: 10)
        currentMoney = 0
        currentReputation = 0
        currentPosition = CGPoint.zero
        image.position = currentPosition
        image.setScale(0.25)
        image.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

}

