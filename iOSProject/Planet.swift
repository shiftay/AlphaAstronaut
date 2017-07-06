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

enum PlanetDescriptions {
    static let ring = "Ring planet"
    static let earth = "Earth planet"
    static let yellow = "Yellow planet"
    static let red = "Red planet"
    static let blue = "Blue planet"
}


class planetBase: SKSpriteNode, InteractiveNode, Planet {
    //let descOverlay = SKSpriteNode(imageNamed: "overlay")
    //let planetPic = SKSpriteNode(imageNamed: "____planet")
    var descOpen: Bool = false
    var hasMinerals: Bool = false
    var hasMetal: Bool = false
    var hasOil: Bool = false
    var planetDesc: SKSpriteNode!
    var descText: String!
    
    func setDescBool() {
        descOpen = !descOpen
    }
    
    func sceneLoaded() {}
    
    func interact() {}
    
    func openPlanetQuest() {
        guard let scene = scene else {
            return
        }
        
        let testPic = SKSpriteNode(imageNamed: "Overlay")
        testPic.size = CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66)
        testPic.position = World.cameraPos!
        testPic.zPosition = 10
        testPic.name = "HUD"
        // yes / no == quest / shop
        let yes = SKSpriteNode(color: .blue, size: CGSize(width: testPic.size.width, height: testPic.size.height / 8))
//        yes.position = CGPoint(x: 0, y: (0 + testPic.size.height * 0.5) - yes.size.height * 0.6)
//        yes.zPosition = 11
//        yes.name = "\(name!)"
        
        let no = SKSpriteNode(imageNamed: "Explore")
        no.size = CGSize(width: testPic.size.width * 0.75, height: testPic.size.height * 0.15)
        no.position = CGPoint(x: 0, y: (0 - testPic.size.height * 0.5) + no.size.height * 0.7)
        no.zPosition = 11
        no.name = "Leave"
        
        testPic.addChild(createOL(HUDSize: testPic.size, halfSize: yes.size))
        testPic.addChild(no)
//        testPic.addChild(yes)
        scene.addChild(testPic)
    }
    
    func openPlanetDesc(name: String) {
        guard let scene = scene else {
            return
        }
        descOpen = true
        let testPic = SKSpriteNode(imageNamed: "Overlay")
        testPic.size = CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66)
        testPic.position = World.cameraPos!
        testPic.zPosition = 10
        testPic.name = "HUD"
        
        planetDesc.size = CGSize(width: testPic.size.width * 0.87, height:  testPic.size.height * 0.4)
        planetDesc.position = CGPoint(x: 0 - 2.5 , y: (0 + planetDesc.size.height * 0.5) + planetDesc.size.height * 0.15)
        planetDesc.name = "PlanetDesc"
        planetDesc.zPosition = 11
        
        
        testPic.addChild(World.createStringOL(string: descText, characterCount: 25, zPos: 15))
        
        let yes = SKSpriteNode(imageNamed: "Land")
        yes.size = CGSize(width: testPic.size.width * 0.45, height: testPic.size.height * 0.15)
        yes.position = CGPoint(x: 0 - yes.size.width * 0.5, y: (0 - testPic.size.height * 0.5) + yes.size.height * 0.7)
        yes.zPosition = 11
        yes.name = "yes"
        
        let no = SKSpriteNode(imageNamed: "Explore")
        no.size = CGSize(width: testPic.size.width * 0.45, height: testPic.size.height * 0.15)
        no.position = CGPoint(x: 0 + yes.size.width * 0.5, y: (0 - testPic.size.height * 0.5) + yes.size.height * 0.7)
        no.zPosition = 11
        no.name = "no"
        
        testPic.addChild(no)
        testPic.addChild(yes)
        testPic.addChild(planetDesc)
        scene.addChild(testPic)
    }
    
    
    func createOL(HUDSize: CGSize, halfSize: CGSize) -> SKSpriteNode {
        let planetOL = SKSpriteNode()
        planetOL.position = CGPoint.zero
        planetOL.zPosition = 19
        
        
        let gather = SKSpriteNode(imageNamed: "Gather")
        gather.size = CGSize(width: HUDSize.width * 0.75, height: HUDSize.height * 0.15)
        gather.zPosition = 20
        gather.position = CGPoint(x: 0, y: 0 + HUDSize.height * 0.25)
        gather.name = "Gather"
        planetOL.addChild(gather)
        
        
        if GameViewController.Player.currentQuest != nil {
            if GameViewController.Player.currentQuest.planetName == name {
                let quest = SKSpriteNode(imageNamed: "Quest")
                quest.size = CGSize(width: HUDSize.width * 0.75, height: HUDSize.height * 0.15)
                quest.zPosition = 20
                quest.position = CGPoint(x: 0, y: gather.position.y - quest.size.height - 20)
                quest.name = "Quest"
                planetOL.addChild(quest)
            }
        }
        return planetOL
    }
    
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !descOpen {
            interact()
        }
    }
}
