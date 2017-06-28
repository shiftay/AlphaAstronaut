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
    
    
    var followPlayer: Bool = false
    var planetTouched: Bool = false // planetTouched
    
    
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
            
            //TODO:
            // create a gameState variable to base a switch off of.
            if !planetTouched {
                if checkBounds(pos: touch.location(in: self)) {
                    cameraNode?.run(SKAction.sequence([SKAction.move(to: touch.location(in: self), duration: 0.5),
                                                       SKAction.run {
                                                        World.cameraPos = self.cameraNode?.position
                        }]))
                }
            } else {
                if let touchedNode = atPoint(touch.location(in: self)) as? SKSpriteNode {
                    switch touchedNode.name! {
                        case "yes":
                            print("Current Selected Planet: \(GameViewController.Player.currentPlanetSelected)")
                            flyShip()
                            if let hud = scene?.childNode(withName: "HUD") {
                                hud.removeFromParent()
                                followPlayer = true
                            }
                        case "no":
                            if let hud = scene?.childNode(withName: "HUD") {
                                hud.removeFromParent()
                                planetTouched = false
                            }
                            if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetTest {
                                planet.descOpen = false
                            }
                            GameViewController.Player.currentPlanetSelected = "none"
                            print("Current Selected Planet: \(GameViewController.Player.currentPlanetSelected)")
                        default:
                            break
                    }
                }
            }

        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        if followPlayer {
            cameraFollowsPlayer()

        }
    }
    
    func flyShip() {
        if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetTest {
            GameViewController.Player.image.zRotation = 0

            let shipPos = GameViewController.Player.image.position
            
            
            let hyp = shipPos.distanceTo(planet.position)
            
            let point: CGPoint!
            
            if shipPos.y > planet.position.y {
                point = CGPoint(x: shipPos.x, y: planet.position.y)
            } else {
                point = CGPoint(x: planet.position.x, y: shipPos.y)
            }
            
            let opp = point.distanceTo(planet.position)
            let angle: CGFloat!
            if shipPos.x > planet.position.x {
                angle = asin(opp / hyp)
            } else {
                angle = asin(opp / hyp) * -1
            }
            
            
            
            
            GameViewController.Player.image.run(SKAction.sequence([SKAction.rotate(toAngle: angle, duration: 0.5, shortestUnitArc: true),
                                                                   SKAction.move(to: planet.position, duration: 5),
                                                                   SKAction.scale(to: 0, duration: 2),
                                                                   SKAction.run {
                                                                    self.followPlayer = false
                                                                    
                                                                    if let planet =
                                                                        self.childNode(withName: GameViewController.Player.currentPlanetSelected)
                                                                            as? planetTest
                                                                    {
                                                                        planet.openPlanetQuest()
                                                                    }
                }]))
        }
    }
    

    func cameraFollowsPlayer() {
        cameraNode?.position = GameViewController.Player.image.position
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
