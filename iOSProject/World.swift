//
//  World.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

protocol Planet {
    func openPlanetDesc(name: String)
    func openPlanetQuest()
}

class World: SKScene {
    static var cameraPos: CGPoint?
    static let updateGauge = "updateGauge"
    let fuelUsageUnit: CGFloat = 32.5
    let distanceUnit: CGFloat = 400.0
    var money: SKLabelNode!
    var background: SKSpriteNode!
    var cameraNode: SKCameraNode?
    var maxWidth: CGFloat = 2500.0
    var maxHeight: CGFloat = 2500.0
    
    var buy: Bool = false
    var amountToSell: Int = 0
    var shopItem: String!

    
    var eventPoppedUp: Bool = false
    var followPlayer: Bool = false
    var visitingPlanet: Bool = false
    var visitingSpaceStation: Bool = false
    var spaceStationTouched: Bool = false {
        didSet {
            if let ssButton = camera?.childNode(withName: "ssButton") as? SKSpriteNode {
                if spaceStationTouched {
                    ssButton.alpha = 0
                } else {
                    ssButton.alpha = 1
                }
            }
        }
    }
    var planetTouched: Bool = false {
        didSet {
            if let ssButton = camera?.childNode(withName: "ssButton") as? SKSpriteNode {
                if planetTouched {
                    ssButton.alpha = 0
                } else {
                    ssButton.alpha = 1
                }
            }
        }
    }// planetTouched
    
    
    override func didMove(to view: SKView) {
        guard let scene = scene else {
            return
        }
  
        
        cameraNode = childNode(withName: "camera") as? SKCameraNode
        maxWidth -= scene.size.width * 0.5
        maxHeight -= scene.size.height * 0.5
        GameViewController.Player.resetImage()
        money = cameraNode?.childNode(withName: "money") as? SKLabelNode
        
        updateMoney()
        //TODO: Add Background Sprite in the actual scene
        //      make limits based on sprite size +/- scene.size
        addChild(GameViewController.Player.image)
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })

        NotificationCenter.default.addObserver(self, selector: #selector(setbool), name: Notification.Name(PlanetUtils.touched), object: nil)
        
        if GameViewController.Player.notOnWorldScene
        {
            cameraNode?.position = GameViewController.Player.currentPosition
            GameViewController.Player.image.position = GameViewController.Player.currentPosition
        }
        
        World.cameraPos = cameraNode?.position
        
    }
    
    func setupScene()
    {
        if GameViewController.Player.currentPlanetSelected.contains("SpaceStation")
        {
            visitingSpaceStation = true
            spaceStationTouched = true
            if let node = childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
            {
                node.openInventory(name: GameViewController.Player.currentPlanetSelected)
            }
        }
        else
        {
            visitingPlanet = true
            planetTouched = true
            if let node = childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetBase
            {
                node.openPlanetQuest()
            }
        }
    }
    
    func setbool() {
        planetTouched = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            worldTouch(firstTouch: touch)
            //TODO:
            // create a gameState variable to base a switch off of.
            

        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        NotificationCenter.default.post(Notification(name: NSNotification.Name(World.updateGauge), object: nil))
        
        if followPlayer {
            cameraFollowsPlayer()

        }
    }
    
    func flyShipToStation() {
        if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation {
            GameViewController.Player.image.zRotation = 0
            var angle2: CGFloat = 0
            let shipPos = GameViewController.Player.image.position
            let hyp = shipPos.distanceTo(planet.position)
            
            let point: CGPoint!
            var adj: CGFloat!
            var opp: CGFloat!
            if shipPos.y > planet.position.y {
                point = CGPoint(x: shipPos.x, y: planet.position.y)
                opp = point.distanceTo(planet.position)
                
                adj = sqrt(pow(hyp, 2) - pow(opp, 2))
                
                if adj < opp {
                    opp = adj
                }
                angle2 = π / 2
            } else {
                point = CGPoint(x: planet.position.x, y: shipPos.y)

                opp = point.distanceTo(planet.position)
                
                adj = sqrt(pow(hyp, 2) - pow(opp, 2))
                
                if adj > opp {
                    opp = adj
                }
            }
            

            let angle: CGFloat!
            if shipPos.x > planet.position.x {
                angle = asin(opp / hyp)
            } else {
                angle = asin(opp / hyp) * -1
                angle2 *= -1
            }
            
            
            
            
            
            
            if hyp == 0 {
                GameViewController.Player.image.run(SKAction.sequence([SKAction.scale(to: 0, duration: 2),
                                                                       SKAction.run {
                                                                        self.followPlayer = false
                                                                        self.visitingSpaceStation = true
                                                                        if let planet =
                                                                            self.childNode(withName: GameViewController.Player.currentPlanetSelected)
                                                                                as? SpaceStation
                                                                        {
                                                                            planet.openInventory(name: (planet.name)!)
                                                                        }
                    }]))
            } else {
                let duration = hyp / distanceUnit
                let fuelSpent = hyp / fuelUsageUnit
                
                if GameViewController.Player.ShipStock.currentFuel - Int(fuelSpent) <= 0 {
                    print("not enough fuel")
                    
                    let hud = childNode(withName: "HUD") as? SKSpriteNode
                    hud?.addChild(createInventoryFull(HUDsize: (hud?.size)!, Message: "Not enough fuel. Land at a closer Planet."))
                } else {
                print("fuelSpent: \(fuelSpent)")
                print("duration: \(duration)")
                GameViewController.Player.ShipStock.currentFuel -= Int(fuelSpent)
                  GameViewController.Player.image.run(SKAction.sequence([SKAction.rotate(toAngle: (angle + angle2) , duration: 0.5),
                                                                   SKAction.move(to: planet.position, duration: TimeInterval(duration)),
                                                                   SKAction.scale(to: 0, duration: 2),
                                                                   SKAction.run {
                                                                    self.followPlayer = false
                                                                    self.visitingSpaceStation = true
                                                                    if let planet =
                                                                        self.childNode(withName: GameViewController.Player.currentPlanetSelected)
                                                                            as? SpaceStation
                                                                    {
                                                                        planet.openInventory(name: (planet.name)!)
                                                                    }
                }]))
                }
            }
        }

    }
    
    // 32.5 --- TO DECIDE FUEL (1%)
    //
    // 800  |  2800
    
    
    
    func flyShip() {

        if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetBase {
            GameViewController.Player.image.zRotation = 0
            var angle2: CGFloat = 0
            let shipPos = GameViewController.Player.image.position
            
            let hyp = shipPos.distanceTo(planet.position)
            
            let point: CGPoint!
            var adj: CGFloat!
            var opp: CGFloat!
            if shipPos.y > planet.position.y {
                point = CGPoint(x: shipPos.x, y: planet.position.y)
                opp = point.distanceTo(planet.position)
                
                adj = sqrt(pow(hyp, 2) - pow(opp, 2))
              
                
                if adj > opp {
                    opp = adj
                }
                
                angle2 = π / 2
                
            } else {
                point = CGPoint(x: planet.position.x, y: shipPos.y)
                //                angle2 = 0
                opp = point.distanceTo(planet.position)
                
                adj = sqrt(pow(hyp, 2) - pow(opp, 2))
                
                if adj < opp {
                    opp = adj
                }
            }

            let angle: CGFloat!
            if shipPos.x > planet.position.x {
                angle = asin(opp / hyp)
                
            } else {
                angle = asin(opp / hyp) * -1
                angle2 *= -1
            }
            
            if hyp == 0 {
                GameViewController.Player.image.run(SKAction.sequence([SKAction.scale(to: 0, duration: 2),
                                                                       SKAction.run {
                                                                        self.followPlayer = false
                                                                        self.visitingPlanet = true
                                                                        if let planet =
                                                                            self.childNode(withName: GameViewController.Player.currentPlanetSelected)
                                                                                as? planetBase
                                                                        {
                                                                            planet.openPlanetQuest()
                                                                        }
                    }]))
            } else {
                let duration = hyp / distanceUnit
                let fuelSpent = hyp / fuelUsageUnit

                if GameViewController.Player.ShipStock.currentFuel - Int(fuelSpent) <= 0 {
                    print("not enough fuel")
                    
                    let hud = childNode(withName: "HUD") as? SKSpriteNode
                    hud?.addChild(createInventoryFull(HUDsize: (hud?.size)!, Message: "Not enough fuel. Land at a closer Planet."))
                } else {
                
                GameViewController.Player.ShipStock.currentFuel -= Int(fuelSpent)
            //TODO: run randomizer to see if event fires, either on planet or on flight.
            
                    GameViewController.Player.image.run(SKAction.sequence([SKAction.rotate(toAngle: (angle + angle2), duration: 0.5),
                                                                   SKAction.move(to: planet.position, duration: TimeInterval(duration)),
                                                                   SKAction.scale(to: 0, duration: 2),
                                                                   SKAction.run {
                                                                    self.followPlayer = false
                                                                    self.visitingPlanet = true
                                                                    if let planet =
                                                                        self.childNode(withName: GameViewController.Player.currentPlanetSelected)
                                                                            as? planetBase
                                                                    {
                                                                        planet.openPlanetQuest()
                                                                    }
                                                                    GameViewController.Player.currentPosition = GameViewController.Player.image.position
                }]))
                }
            }
        }
    }
    

    func cameraFollowsPlayer() {
        cameraNode?.position = GameViewController.Player.image.position
        World.cameraPos = cameraNode?.position
    }
    

}
