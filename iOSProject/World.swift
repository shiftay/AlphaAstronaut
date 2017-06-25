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

class World: SKScene {
    static var cameraPos: CGPoint?
    var background: SKSpriteNode!
    var cameraNode: SKCameraNode?
    let maxWidth: CGFloat = 2500.0
    
    
    var planetTouched: Bool = false // planetTouched
    
    
    override func didMove(to view: SKView) {
        print("WorldView")
        guard let scene = scene else {
            return
        }
        
        
        
        
        cameraNode = childNode(withName: "camera") as? SKCameraNode
        World.cameraPos = cameraNode?.position
        
        //TODO: Add Background Sprite in the actual scene
        // make limits based on sprite size +/- scene.size
        background = SKSpriteNode(color: .black, size: scene.size)
        
        addChild(background)
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(setbool), name: Notification.Name(Planet.touched), object: nil)
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
                        case "no":
                            if let hud = scene?.childNode(withName: "HUD") {
                                GameViewController.Player.currentPlanetSelected = "none"
                                hud.removeFromParent()
                                planetTouched = false
                            }
                            print("Current Selected Planet: \(GameViewController.Player.currentPlanetSelected)")
                        default:
                            break
                    }
//                    if touchedNode.name == "yes" {
//                        if let hud = scene?.childNode(withName: "HUD") {
//                            World.currentPlanetSelected = "none"
//                            hud.removeFromParent()
//                            planetTouched = false
//                        }
//                    }
                }
            }

        }
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
