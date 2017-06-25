//
//  PlayersShip.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation

class PlayersShip {
    let name = "Player"
    var ShipStock: ShipUtilities!
//    var ShipRoster
    var currentMoney: Int
    var currentReputation: Int
    var currentQuest: Quest!
    var currentPlanetSelected: String = "none"
    
    init() {
        print("PSHIP")
        ShipStock = ShipUtilities(maxFuel: 100, maxHullSpace: 500, maxShields: 10)
        currentMoney = 0
        currentReputation = 0
    }

}

