//
//  PlayerUtils.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation

class ShipUtilities {
    var maxFuel: Int
    var currentFuel: Int {
        didSet {
            if currentFuel > maxFuel {
                currentFuel = maxFuel
            }
            
            if currentFuel < 0 {
                currentFuel = 0
            }
        }
    }
    
    var maxHullSpace: Int
    
    var currentHullSpace: Int {
        didSet {
            if currentHullSpace > maxHullSpace {
                currentHullSpace = maxHullSpace
            }
            
            if currentHullSpace < 0 {
                currentHullSpace = 0
            }
        }
    }

    var maxShields: Int
    
    var currentShields: Int {
        didSet {
            if currentShields > maxShields {
                currentShields = maxShields
            }
            
            if currentShields < 0 {
                currentShields = 0
            }
        }
    }

    init(maxFuel: Int, maxHullSpace: Int, maxShields: Int) {
        self.maxFuel = maxFuel
        self.maxHullSpace = maxHullSpace
        self.maxShields = maxShields
        currentFuel = maxFuel
        currentHullSpace = 0
        currentShields = 0
    }
}
