//
//  World-Touch.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//
import Foundation
import SpriteKit

extension World {
    
    func worldTouch(firstTouch: UITouch) {
        if !(cameraNode?.hasActions())! {
        
            if !planetTouched && !spaceStationTouched {

                moveCamera(firstTouch: firstTouch)
            }
        
            if planetTouched && !visitingPlanet {
                handleDescBox(firstTouch: firstTouch, isSpaceStation: false)
            }

            if spaceStationTouched && !visitingSpaceStation {
                handleDescBox(firstTouch: firstTouch, isSpaceStation: true)
            }
            
            if planetTouched || spaceStationTouched {
                if eventPoppedUp {
                    handleREvent()
                }
            }
        
            if visitingSpaceStation {
                let hud = childNode(withName: "HUD") as? SKSpriteNode
                if let _ = hud?.childNode(withName: "ShopPopup") {
                    handleShopPopup(firstTouch: firstTouch)
                } else if let _ = hud?.childNode(withName: "QuestPopup") {
                    handleQuestPopup(firstTouch: firstTouch)
                } else {
                    handleSSOL(firstTouch: firstTouch)
                }
                
                
                
               

            }
        
            if visitingPlanet {
                handlePlanetOL(firstTouch: firstTouch)
            }
        }
    }
    
    
    func handleREvent() {
        //TODO handle random event
    }
    
    
    func handleQuestPopup(firstTouch: UITouch) {
        let spaceStation = childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
        
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
            switch touchedNode.name! {
            case "okay0":
                GameViewController.Player.currentQuest = spaceStation?.quests[0]
                if let popup = hud?.childNode(withName: "QuestPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                }

                
            case "okay1":
                GameViewController.Player.currentQuest = spaceStation?.quests[1]
                if let popup = hud?.childNode(withName: "QuestPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                }


            case "cancel":
                if let popup = hud?.childNode(withName: "QuestPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                }
            default:
                break
            }
        }
    }
    
    
    func handleShopPopup(firstTouch: UITouch) {
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        let text = hud?.childNode(withName: "ShopPopup")?.childNode(withName: "numText") as? SKLabelNode
        let sellText = hud?.childNode(withName: "ShopPopup")?.childNode(withName: "maxText") as? SKLabelNode
        
        
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
            
            switch touchedNode.name! {
            case "plus":
                //TODO: Logic preventing above max amount
                if amountToSell + 1 >= returnMax() {
                    amountToSell = returnMax()
                } else {
                    amountToSell += 1
                }
                sellText?.text = buy ? buyPrice() : sellPrice()
                text?.text = "\(amountToSell)"
            case "minus":
                if amountToSell - 1 < 0 {
                    amountToSell = 0
                } else {
                    amountToSell -= 1
                }
                sellText?.text = buy ? buyPrice() : sellPrice()
                text?.text = "\(amountToSell)"
            case "MAX":
                amountToSell = returnMax()
                sellText?.text = buy ? buyPrice() : sellPrice()
                text?.text = "\(amountToSell)"
            case "CLEAR":
                amountToSell = 0
                sellText?.text = "$0"
                text?.text = "\(amountToSell)"
            case "okay":
                //TODO: sell / buy
                if buy {
                    buyItem()
                } else {
                    sellItem()
                }
                
                if let popup = hud?.childNode(withName: "ShopPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                    //TODO: set stored values to none / 0
                    amountToSell = 0
                }
                print("okay")
            case "cancel":
                if let popup = hud?.childNode(withName: "ShopPopup") as? SKSpriteNode {
                    popup.removeFromParent()
                    amountToSell = 0
                    //TODO: set stored values to none / 0
                }
            default:
                break
            }
            
        }
    }
    
    
    func buyPrice() -> String {
        var retVal: String = ""
        let spaceStation = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation

        switch shopItem {
        case "fuel" :
            retVal = "$\(CGFloat(amountToSell) * (spaceStation?.fuelRate)!)"
        case "minerals":
            retVal = "$" + String(format: "%.2f", CGFloat(amountToSell) * (spaceStation?.mineralSell)!)
        case "oil":
            retVal = "$\(CGFloat(amountToSell) * (spaceStation?.oilSell)!)"
        case "metal" :
            retVal = "$\(CGFloat(amountToSell) * (spaceStation?.metalSell)!)"
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
            retVal = "$" + String(format: "%.2f", "\(CGFloat(amountToSell) * (spaceStation?.mineralSell)!)")
        case "oil":
            retVal = "$\(CGFloat(amountToSell) * (spaceStation?.oilSell)!)"
        case "metal" :
            retVal = "$\(CGFloat(amountToSell) * (spaceStation?.metalSell)!)"
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
    
    
    
    func handlePlanetOL(firstTouch: UITouch) {
        print("handlePlanetOL")
        //TODO: Gather: Fuel -> Loads other scene
        //              Materials -> Loads other scene
        //      Leave:  Closes the HUD
        //      Quest:  Hand in quest or accept cargo
    }

    func handleSSOL(firstTouch: UITouch) {
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        let spaceStation = childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
        
        //TODO: In order for touch to work with inventory, each space station needs the same amount of things to sell
        //      Player can only SELL the resources
        //      if other thing is open, okay, cancel, max, + / -
        //
        
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKNode {
            switch touchedNode.name! {
            case "Shop":
                if let quest = hud?.childNode(withName: "QuestPage") as? SKSpriteNode {
                    quest.removeFromParent()
                    let half = hud?.childNode(withName: "Shop") as? SKSpriteNode
                    hud?.addChild((spaceStation?.generateShopPage(HUDSize: hud!.size, halfSize: half!.size))!)
                }
            case "Quest":
                if let shop = hud?.childNode(withName: "ShopPage") as? SKSpriteNode {
                    shop.removeFromParent()
                    let half = hud?.childNode(withName: "Shop") as? SKSpriteNode
                    hud?.addChild((spaceStation?.generateQuestPage(HUDSize: hud!.size, halfSize: half!.size))!)
                }
            case "buy1":
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                shopItem = "fuel"
                buy = true
                print("buy fuel")
            case "buy2":
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                shopItem = "minerals"
                buy = true
                print("buy minerals")
            case "buy3":
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                shopItem = "oil"
                buy = true
                print("buy oil")
            case "buy4":
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                shopItem = "metal"
                buy = true
                print("buy metal")
            case "sell1":
                print("sell minerals")
                shopItem = "minerals"
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                buy = false
            case "sell2":
                print("sell oil")
                shopItem = "oil"
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                buy = false
            case "sell3":
                print("sell metal")
                shopItem = "metal"
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                buy = false
            case "quest1":
                if GameViewController.Player.currentQuest == nil {
                    hud?.addChild(createQuestBox(HUDsize: hud!.size, QuestNumber: 0))
                } else {
                    print("you already have a quest")
                }
                //TODO: Only allow if player doesnt have any quests.

            case "quest2":
                print("show quest box")
                
            default:
                break
            }
            
        }
    }

    func handleDescBox(firstTouch: UITouch, isSpaceStation: Bool) {
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
            switch touchedNode.name! {
            case "yes":
                if isSpaceStation {
                    flyShipToStation()
                } else {
                    flyShip()
                }
                
                if let hud = scene?.childNode(withName: "HUD") {
                    hud.removeFromParent()
                    followPlayer = true
                }
            case "no":
                if let hud = scene?.childNode(withName: "HUD") {
                    hud.removeFromParent()
                }
                
                if isSpaceStation {
                    if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation {
                        planet.descOpen = false
                    }
                    spaceStationTouched = false
                } else {
                    if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetBase {
                        planet.descOpen = false
                    }
                    planetTouched = false
                }
                
                GameViewController.Player.currentPlanetSelected = "none"
            default:
                break
            }
        }
    }

    func moveCamera(firstTouch: UITouch) {
        if checkBounds(pos: firstTouch.location(in: self)) {
            cameraNode?.run(SKAction.sequence([SKAction.move(to: firstTouch.location(in: self), duration: 0.5),
                                               SKAction.run {
                                                World.cameraPos = self.cameraNode?.position
                }]))
        }
    }
    
    func createSellBox(HUDsize: CGSize) -> SKSpriteNode {
        let bg = SKSpriteNode(color: .black, size: (scene?.size)!)
        bg.alpha = 0.90
        bg.zPosition = -10
        bg.position = CGPoint.zero
        bg.name = "bg"

        let box = SKSpriteNode(color: .white, size: CGSize(width: HUDsize.width, height: HUDsize.height * 0.5))
        box.zPosition = 52
        box.position = CGPoint.zero
        box.name = "ShopPopup"
        box.addChild(bg)

        let number = SKSpriteNode(color: .red, size: CGSize(width: HUDsize.width * 0.33, height: HUDsize.width * 0.33))
        number.zPosition = 53
        number.position = CGPoint(x: 0, y: 0 + number.size.height * 0.5)
        number.name = "number"
        box.addChild(number)
        
        let text = SKLabelNode(fontNamed: "Arial")
        text.zPosition = 54
        text.verticalAlignmentMode = .center
        text.position = number.position
        text.text = "0"
        text.name = "numText"
        text.fontColor = .white
        text.fontSize = 100
        box.addChild(text)
        
        
        let plus = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.1, height: HUDsize.width * 0.1))
        plus.zPosition = 53
        plus.position = CGPoint(x: number.position.x + HUDsize.width * 0.35, y: number.position.y)
        plus.name = "plus"
        box.addChild(plus)
        
        let minus = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.1, height: HUDsize.width * 0.1))
        minus.zPosition = 53
        minus.position = CGPoint(x: number.position.x - HUDsize.width * 0.35, y: number.position.y)
        minus.name = "minus"
        box.addChild(minus)
        
        let maxArea = SKSpriteNode(color: .black, size: CGSize(width: HUDsize.width * 0.35, height: HUDsize.width * 0.15))
        maxArea.zPosition = 53
        maxArea.position = CGPoint(x: 0, y: number.position.y - number.size.height)
        maxArea.name = "maxArea"
        box.addChild(maxArea)
        
        let max = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.15, height: HUDsize.width * 0.1))
        max.zPosition = 53
        max.position = CGPoint(x: plus.position.x, y: maxArea.position.y)
        max.name = "MAX"
        box.addChild(max)
        
        let clear = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.15, height: HUDsize.width * 0.1))
        clear.zPosition = 53
        clear.position = CGPoint(x: minus.position.x, y: maxArea.position.y)
        clear.name = "CLEAR"
        box.addChild(clear)
        
        let mText = SKLabelNode(fontNamed: "Arial")
        mText.zPosition = 54
        mText.verticalAlignmentMode = .center
        mText.position = maxArea.position
        mText.text = "$0"
        mText.name = "maxText"
        mText.fontColor = .white
        mText.fontSize = 35
        box.addChild(mText)
        
        
        
        let okay = SKSpriteNode(color: .blue, size: CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15))
        box.addChild(okay)
        okay.position = CGPoint(x: 0 - okay.size.width * 0.5, y: (0 - box.size.height * 0.5) + okay.size.height * 0.5)
        okay.zPosition = 53
        okay.name = "okay"
        
        let cancel = SKSpriteNode(color: .purple, size: CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15))
        box.addChild(cancel)
        cancel.position = CGPoint(x: 0 + cancel.size.width * 0.5, y: (0 - box.size.height * 0.5) + cancel.size.height * 0.5)
        cancel.zPosition = 53
        cancel.name = "cancel"
        
        return box
    }
    
    
    func createQuestBox(HUDsize: CGSize, QuestNumber: Int) -> SKSpriteNode {
        let spaceStation = childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
        
        let bg = SKSpriteNode(color: .black, size: (scene?.size)!)
        bg.alpha = 0.90
        bg.zPosition = -10
        bg.position = CGPoint.zero
        bg.name = "bg"
        
        let box = SKSpriteNode(color: .white, size: CGSize(width: HUDsize.width, height: HUDsize.height * 0.5))
        box.zPosition = 52
        box.position = CGPoint.zero
        box.name = "QuestPopup"
        box.addChild(bg)

        
        let description = SKSpriteNode(color:.red, size: CGSize(width: box.size.width * 0.66, height: box.size.height * 0.66))
        description.zPosition = 53
        description.position = CGPoint(x: 0, y: 0 + description.size.height * 0.125)
        description.name = "desc"
        box.addChild(description)
        
        let descText = SKLabelNode(fontNamed: "Arial")
        descText.position = description.position
        descText.zPosition = 54
        descText.fontColor = .black
        descText.fontSize = 20
        descText.horizontalAlignmentMode = .center
        descText.name = "descT"
        print("\(String(describing: spaceStation?.quests[QuestNumber].description!))")
        descText.text = spaceStation?.quests[QuestNumber].description!
        box.addChild(descText)
        //TODO: Setup quest within the description box.
        
        let okay = SKSpriteNode(color: .blue, size: CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15))
        box.addChild(okay)
        okay.position = CGPoint(x: 0 - okay.size.width * 0.5, y: (0 - box.size.height * 0.5) + okay.size.height * 0.5)
        okay.zPosition = 53
        okay.name = "okay\(QuestNumber)"
        
        let cancel = SKSpriteNode(color: .purple, size: CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15))
        box.addChild(cancel)
        cancel.position = CGPoint(x: 0 + cancel.size.width * 0.5, y: (0 - box.size.height * 0.5) + cancel.size.height * 0.5)
        cancel.zPosition = 53
        cancel.name = "cancel\(QuestNumber)"
        
        
        
        return box
    }
    
    
    
    
    
    // TODO:    Decide how large the solar system is.
    func checkBounds(pos: CGPoint) -> Bool {
        var retVal: Bool = true
        
        if pos.x > maxWidth || pos.x < -maxWidth {
            retVal = false
        }
        
        if pos.y > maxHeight || pos.y < -maxHeight {
            retVal = false
        }
        return retVal
    }

    
}
