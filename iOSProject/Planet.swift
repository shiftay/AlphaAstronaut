//
//  planetTest.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

enum PlanetUtils {
    static let touched = "planet_touched"
}

//enum PlanetDescriptions {
//    
//}

class planetTest: SKSpriteNode, InteractiveNode, Planet {
    //let descOverlay = SKSpriteNode(imageNamed: "overlay")
    //let planetPic = SKSpriteNode(imageNamed: "____planet")
    var descOpen: Bool = false
    
    func setDescBool() {
        descOpen = !descOpen
    }
    
    func sceneLoaded() {
        print("test")
        name = "planet1"
        isUserInteractionEnabled = true
    }
    
    func interact() {
        //TODO: load up a overlay for the planet in question.
        //      overlay can be made as a sprite
        //      the information for each planet/spacestation will be stored within a file like this.
        //      and the overlay will be built using this information.
        if !descOpen {
            GameViewController.Player.currentPlanetSelected = name!
            openPlanetDesc()
            NotificationCenter.default.post(Notification(name: NSNotification.Name(PlanetUtils.touched), object: nil))
        }

    }
    
    func openPlanetQuest() {
        //TODO: create the quest layout for the player.
        //      create shop per planet
        //      create gather type on planet.
        print("Hello, quest!?")
    }
    
    func openPlanetDesc() {
        guard let scene = scene else {
            return
        }
        descOpen = true
        let testPic = SKSpriteNode(color: .green, size: CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66))
        
        testPic.position = World.cameraPos!
        testPic.zPosition = 10
        testPic.name = "HUD"

        let yes = SKSpriteNode(color: .blue, size: CGSize(width: testPic.size.width * 0.5, height: testPic.size.height * 0.25))
        yes.position = CGPoint(x: 0 - yes.size.width * 0.5, y: (0 - testPic.size.height * 0.5) + yes.size.height * 0.5)
        yes.zPosition = 11
        yes.name = "yes"
        
        let no = SKSpriteNode(color: .purple, size: CGSize(width: testPic.size.width * 0.5, height: testPic.size.height * 0.25))
        no.position = CGPoint(x: 0 + yes.size.width * 0.5, y: (0 - testPic.size.height * 0.5) + yes.size.height * 0.5)
        no.zPosition = 11
        no.name = "no"
        
        testPic.addChild(no)
        testPic.addChild(yes)
        scene.addChild(testPic)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !descOpen {
            interact()
        }
    }
}
