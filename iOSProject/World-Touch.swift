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

    }
    
    func handleShopPopup(firstTouch: UITouch) {
        let hud = childNode(withName: "HUD") as? SKSpriteNode
        let text = hud?.childNode(withName: "ShopPopup")?.childNode(withName: "numText") as? SKLabelNode
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
            
            switch touchedNode.name! {
            case "plus":
                print("plus")
                
                //TODO: Logic preventing above max amount
                amountToSell += 1
                print("\(amountToSell)")
                text?.text = "\(amountToSell)"
                
                
                
                
            case "minus":
                if amountToSell - 1 < 0 {
                    amountToSell = 0
                } else {
                    amountToSell -= 1
                }

                text?.text = "\(amountToSell)"
                
                print("minus")
            case "MAX":
                amountToSell = returnMax()
                text?.text = "\(amountToSell)"
                
                
                
                
            case "okay":
                //TODO: sell / buy
                if buy {
                    
                } else {
                    
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
        // At all times there will be 4 things to buy: FUEL, 
        
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
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
            case "buy":
                print("buy")
                //TODO: put a check that something is set within player
                hud?.addChild(createSellBox(HUDsize: hud!.size))
                shopItem = "minerals"
                buy = true
            case "sell":
                print("sell")
                shopItem = "minerals"
                buy = false
            //TODO: set this up.
            case "buy1":
                print("buy fuel")
            case "buy2":
                print("buy minerals")
            case "sell1":
                print("sell minerals")
            case "sell2":
                print("sell wood")
                
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
//        let bg = SKSpriteNode(color: .black, size: (scene?.size)!)
//        bg.alpha = 0.90
//        bg.zPosition = 0
//        bg.position = CGPoint.zero

        let box = SKSpriteNode(color: .white, size: CGSize(width: HUDsize.width, height: HUDsize.height * 0.5))
        box.zPosition = 52
        box.position = CGPoint.zero
        box.name = "ShopPopup"
//        box.addChild(bg)

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
        plus.position = CGPoint(x: number.position.x + HUDsize.width * 0.25, y: number.position.y)
        plus.name = "plus"
        box.addChild(plus)
        
        let minus = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.1, height: HUDsize.width * 0.1))
        minus.zPosition = 53
        minus.position = CGPoint(x: number.position.x - HUDsize.width * 0.25, y: number.position.y)
        minus.name = "minus"
        box.addChild(minus)
        
        let max = SKSpriteNode(color: .cyan, size: CGSize(width: HUDsize.width * 0.25, height: HUDsize.width * 0.15))
        max.zPosition = 53
        max.position = CGPoint(x: 0, y: number.position.y - number.size.height * 0.75)
        max.name = "MAX"
        box.addChild(max)
        
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
