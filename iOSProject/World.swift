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
    func openPlanetDesc()
    func openPlanetQuest()
}


class World: SKScene {
    static var cameraPos: CGPoint?
    var background: SKSpriteNode!
    var cameraNode: SKCameraNode?
    let maxWidth: CGFloat = 2500.0
    
    
    var followPlayer: Bool = false
    var planetTouched: Bool = false // planetTouched
    
    
    override func didMove(to view: SKView) {
        guard let scene = scene else {
            return
        }
        
        cameraNode = childNode(withName: "camera") as? SKCameraNode
        World.cameraPos = cameraNode?.position
        
        //TODO: Add Background Sprite in the actual scene
        //      make limits based on sprite size +/- scene.size
        background = SKSpriteNode(color: .black, size: scene.size)
        addChild(background)
        
        if GameViewController.Player.currentPosition != GameViewController.Player.image.position {
            GameViewController.Player.image.position = GameViewController.Player.currentPosition
        }
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
                            if let planet = scene?.childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetTest {
                                GameViewController.Player.image.zRotation = 0
//                                print("ship angle: \(GameViewController.Player.image.zRotation)")
//                                print("planet angle: \(planet.position.angle)")
//                                print("planet angle2: \(planet.position.angle.radiansToDegrees())")
//                                print("ship angle2: \(GameViewController.Player.image.position.angle)")
//                                let short = shortestAngleBetween(GameViewController.Player.image.position.angle, angle2: planet.position.angle)
//                                print("shortest angle: \(short)")
//                                print("shortest angle2: \(short.radiansToDegrees())")
//                                
//                                let test = GameViewController.Player.image.position.angle + short
//                                print("test: \(test)")
//                                print("test2: \(test.radiansToDegrees())")
//                                print("test3: \(test.degreesToRadians())")
                                
                                GameViewController.Player.image.run(SKAction.sequence([SKAction.rotate(toAngle: -planet.position.angle, duration: 0),
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
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint) {
        
        
        
        
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
        
        if pos.y > maxWidth || pos.y < -maxWidth {
            retVal = false
        }
        

        return retVal
    }
}
