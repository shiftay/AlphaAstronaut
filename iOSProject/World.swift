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
    var background: SKSpriteNode!
    var cameraNode: SKCameraNode?
    var maxWidth: CGFloat = 2500.0
    var maxHeight: CGFloat = 2500.0
    var eventPoppedUp: Bool = false
    
    var followPlayer: Bool = false
    
    var visitingPlanet: Bool = false
    var visitingSpaceStation: Bool = false
    var spaceStationTouched: Bool = false
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
        
        maxWidth -= scene.size.width * 0.5
        maxHeight -= scene.size.height * 0.5
        
        cameraNode = childNode(withName: "camera") as? SKCameraNode
        World.cameraPos = cameraNode?.position
        
        //TODO: Add Background Sprite in the actual scene
        //      make limits based on sprite size +/- scene.size
        addChild(GameViewController.Player.image)
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })

        NotificationCenter.default.addObserver(self, selector: #selector(setbool), name: Notification.Name(PlanetUtils.touched), object: nil)
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
            
            
            
            GameViewController.Player.image.run(SKAction.sequence([SKAction.rotate(toAngle: (angle + angle2) , duration: 0.5),
                                                                   SKAction.move(to: planet.position, duration: 5),
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

            //TODO: run randomizer to see if event fires, either on planet or on flight.
            
            GameViewController.Player.image.run(SKAction.sequence([SKAction.rotate(toAngle: (angle + angle2), duration: 0.5),
                                                                   SKAction.move(to: planet.position, duration: 5),
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
                }]))
        }
    }
    

    func cameraFollowsPlayer() {
        cameraNode?.position = GameViewController.Player.image.position
        World.cameraPos = cameraNode?.position
    }
    

}
