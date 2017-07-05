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
        let spaceStation = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation

        switch shopItem {
        case "minerals":
            GameViewController.Player.currentMinerals -= amountToSell
            GameViewController.Player.currentMoney += CGFloat(amountToSell) * (spaceStation?.mineralSell)!
        case "oil":
            GameViewController.Player.currentOil -= amountToSell
            GameViewController.Player.currentMoney += CGFloat(amountToSell) * (spaceStation?.oilSell)!
        case "metal" :
            GameViewController.Player.currentMetalParts -= amountToSell
            GameViewController.Player.currentMoney += CGFloat(amountToSell) * (spaceStation?.metalSell)!
        default:
            break
        }
        
        updateMoney()
    }
    
    func buyItem() {
        let test = GameViewController.Player
        let spaceStation = scene?.childNode(withName: (test?.currentPlanetSelected)!) as? SpaceStation
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        
        if !enoughMoney() {
            print("not enough money")
            hud?.addChild(createInventoryFull(HUDsize: hud!.size, Message: "Not enough money!"))
            return
        }
        
        switch shopItem {
        case "fuel" :
            GameViewController.Player.ShipStock.currentFuel += amountToSell
            GameViewController.Player.currentMoney -= (spaceStation?.fuelRate)! * CGFloat(amountToSell)
        case "minerals":
            GameViewController.Player.currentMinerals += amountToSell
            GameViewController.Player.currentMoney -= (spaceStation?.mineralRate)! * CGFloat(amountToSell)
        case "oil":
            GameViewController.Player.currentOil += amountToSell
            GameViewController.Player.currentMoney -= (spaceStation?.oilRate)! * CGFloat(amountToSell)
        case "metal" :
            GameViewController.Player.currentMetalParts += amountToSell
            GameViewController.Player.currentMoney -= (spaceStation?.metalRate)! * CGFloat(amountToSell)
        default:
            break
        }
        
        updateMoney()
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
    
    public static func createStringOL(string: String, characterCount: Int, pos: CGPoint = CGPoint.zero, zPos: CGFloat = 50.0) -> SKSpriteNode {
        let retVal = SKSpriteNode()
        retVal.position = pos
        retVal.zPosition = 15
        var holderArray: [String] = []
        let strArr = string.components(separatedBy: " ")
        
        if strArr.count > 5 {
            var arrayCount = 0
            var countChars = 0

            holderArray.append("")

            for i in 0...strArr.count-1 {
                holderArray[arrayCount] += strArr[i]
                holderArray[arrayCount] += " "
                countChars += 1 // to account for the space
                countChars += strArr[i].characters.count
                if countChars >= characterCount {
                    arrayCount += 1
                    countChars = 0
                    holderArray.append("")
                }
            }
        } else {
            holderArray.append("")
            for x in 0...strArr.count - 1 {
                holderArray[0] += strArr[x]
                holderArray[0] += " "
            }
        }
        
        for x in 0...holderArray.count - 1 {
            let text = SKLabelNode(fontNamed: "Arial")
            text.fontColor = .white
            text.fontSize = 35
            text.zPosition = zPos
            text.position = CGPoint(x: retVal.position.x, y: 0 - text.fontSize * CGFloat(x))
            //(retVal.position.y + 50.0) - CGFloat(50 * x)
            text.text = holderArray[x]
            text.horizontalAlignmentMode = .center
            retVal.addChild(text)
        }


        return retVal
    }
    
    func updateMoney() {
        money.text = "$" + String(format: "%.2f", GameViewController.Player.currentMoney)
        money.fontName = "Arial"
    }
    
}
