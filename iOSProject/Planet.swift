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

enum PlanetList {
    static let ring = "ring"
    static let blue = "blue"
    static let red = "red"
    static let earth = "earth"
    static let yellow = "yellow"
}

class planetBase: SKSpriteNode, InteractiveNode, Planet {
    //let descOverlay = SKSpriteNode(imageNamed: "overlay")
    //let planetPic = SKSpriteNode(imageNamed: "____planet")
    var descOpen: Bool = false
    
    func setDescBool() {
        descOpen = !descOpen
    }
    
    func sceneLoaded() {}
    
    func interact() {}
    
    func openPlanetQuest() {
        //TODO: create the quest layout for the player.
        //      create shop per planet
        //      create gather type on planet.
        print("Hello, quest!?")
    }
    
    func openPlanetDesc(name: String) {
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
