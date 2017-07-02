//
//  World-ShopUtils.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-07-02.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

extension World {
    
    func buyPrice() -> String {
        var retVal: String = ""
        let spaceStation = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
        
        switch shopItem {
        case "fuel" :
            retVal = "$" + String(format: "%.2f", CGFloat(amountToSell) * (spaceStation?.fuelRate)!)
        case "minerals":
            retVal = "$" + String(format: "%.2f", CGFloat(amountToSell) * (spaceStation?.mineralSell)!)
        case "oil":
            retVal = "$" + String(format: "%.2f", CGFloat(amountToSell) * (spaceStation?.oilSell)!)
        case "metal" :
            retVal = "$" + String(format: "%.2f", CGFloat(amountToSell) * (spaceStation?.metalSell)!)
        default:
            break
        }
        
        return retVal
    }
    
    func sellPrice() -> String {
        var retVal: String = ""
        let spaceStation = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
        
        switch shopItem {
        case "minerals":
            retVal = "$" + String(format: "%.2f", CGFloat(amountToSell) * (spaceStation?.mineralRate)!)
        case "oil":
            retVal = "$" + String(format: "%.2f", CGFloat(amountToSell) * (spaceStation?.oilRate)!)
        case "metal" :
            retVal = "$" + String(format: "%.2f", CGFloat(amountToSell) * (spaceStation?.metalRate)!)
        default:
            break
        }
        
        return retVal
    }
    
    func sellItem() {
        let test = GameViewController.Player
        
        switch shopItem {
        case "fuel" :
            test?.ShipStock.currentFuel -= amountToSell
        case "minerals":
            test?.currentMinerals -= amountToSell
        case "oil":
            test?.currentOil -= amountToSell
        case "metal" :
            test?.currentMetalParts -= amountToSell
        default:
            break
        }
    }
    
    func buyItem() {
        let test = GameViewController.Player
        
        if !enoughMoney() {
            print("not enough money")
            // TODO: Open pop up saying you dont have enough money.
            return
        }
        
        switch shopItem {
        case "fuel" :
            test?.ShipStock.currentFuel += amountToSell
        case "minerals":
            test?.currentMinerals += amountToSell
        case "oil":
            test?.currentOil += amountToSell
        case "metal" :
            test?.currentMetalParts += amountToSell
        default:
            break
        }
    }
    
    func enoughMoney() -> Bool {
        var retVal: Bool = false
        let player = GameViewController.Player
        let spaceStation = scene?.childNode(withName: (player?.currentPlanetSelected)!) as? SpaceStation
        
        switch shopItem {
        case "fuel" :
            if (player?.currentMoney)! >= ((spaceStation?.fuelRate)! * CGFloat(amountToSell)) {
                retVal = true
            }
        case "minerals":
            if (player?.currentMoney)! >= ((spaceStation?.mineralSell)! * CGFloat(amountToSell)) {
                retVal = true
            }
        case "oil":
            if (player?.currentMoney)! >= ((spaceStation?.oilSell)! * CGFloat(amountToSell)) {
                retVal = true
            }
        case "metal" :
            if (player?.currentMoney)! >= ((spaceStation?.metalSell)! * CGFloat(amountToSell)) {
                retVal = true
            }
        default:
            break
        }
        
        
        return retVal
    }
    
    func returnMax() -> Int {
        var retVal: Int = 0
        let test = GameViewController.Player
        
        if buy {
            if shopItem == "fuel" {
                retVal = (test?.ShipStock.maxFuel)! - (test?.ShipStock.currentFuel)!
            } else {
                retVal = (test?.ShipStock.maxHullSpace)! - (test?.ShipStock.currentHullSpace)!
            }
        } else {
            switch shopItem {
            case "minerals":
                retVal = (test?.currentMinerals)!
            case "oil":
                retVal = (test?.currentOil)!
            case "metal":
                retVal = (test?.currentMetalParts)!
            default:
                break
            }
        }
        
        return retVal
    }
}
