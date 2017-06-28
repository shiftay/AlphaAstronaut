//
//  SpaceStation.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

enum SSDesc {
    static let alpha = "Hello this is alpha"
    static let beta = "Hello this is beta"
}



class SpaceStation: SKSpriteNode, InteractiveNode {
    // all rates are multipliers
    let fuelRate: CGFloat = 2.0
    var mineralRate: CGFloat = 100.0
    var woodRate: CGFloat = 50.0
    var plantRate: CGFloat = 10.0
    var descOpen: Bool = false
    

    func sceneLoaded() {}
    
    func interact() {}
    
    func openInventory() {
//        guard let scene = scene else {
//            return
//        }
 
        
    }
    
    func openDesc(name: String) {
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
    
    func randomizeRates() {
        let multiplier = CGFloat.random(min: 0.1, max: 1)
        print("\(multiplier)")
        
        woodRate *= multiplier
        mineralRate *= multiplier
        plantRate *= multiplier
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !descOpen {
            interact()
        }
    }
}
