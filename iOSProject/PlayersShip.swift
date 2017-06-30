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
    var currentMinerals: Int {
        didSet {
            ShipStock.currentHullSpace -= oldValue
            ShipStock.currentHullSpace += currentMinerals
        }
    }
    
    var currentMetalParts: Int {
        didSet {
            ShipStock.currentHullSpace -= oldValue
            ShipStock.currentHullSpace += currentMetalParts
        }
    }
    
    var currentOil: Int {
        didSet {
            ShipStock.currentHullSpace -= oldValue
            ShipStock.currentHullSpace += currentOil
        }
    }
    
    init() {
        ShipStock = ShipUtilities(maxFuel: 100, maxHullSpace: 100, maxShields: 10)
        currentMoney = 0
        currentReputation = 0
        currentPosition = CGPoint.zero
        currentMinerals = 0
        currentOil = 0
        currentMetalParts = 0
        image.position = currentPosition
        image.setScale(0.25)
        image.zPosition = 6
        image.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

}

