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
                handleSSOL(firstTouch: firstTouch)
            }
        
            if visitingPlanet {
                handlePlanetOL(firstTouch: firstTouch)
            }
        }
    }
    
    
    func handleREvent() {
        //TODO:
    }
    
    func handlePlanetOL(firstTouch: UITouch) {
        print("handlePlanetOL")
        //TODO: Gather: Fuel -> Loads other scene
        //              Materials -> Loads other scene
        //      Leave:  Closes the HUD
        //      Quest:  Hand in quest or accept cargo
    }

    func handleSSOL(firstTouch: UITouch) {
        let hud = childNode(withName: "HUD")
        
        
        //TODO: In order for touch to work with inventory, each space station needs the same amount of things to sell
        //      Player can only SELL the resources
        //      if other thing is open, okay, cancel, max, + / -
        //      
        
        
        if let touchedNode = atPoint(firstTouch.location(in: self)) as? SKSpriteNode {
            switch touchedNode.name! {
            case "Shop":
                if let quest = hud?.childNode(withName: "QuestPage") as? SKSpriteNode {
                    print("\(quest.position.x)")
                }
            case "Quest":
                if let shop = hud?.childNode(withName: "ShopPage") as? SKSpriteNode {
                    print("\(shop.position.x)")
                }
            case "buy":
                break
            case "sell":
                break
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
