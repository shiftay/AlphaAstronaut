//
//  planetTest.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

struct Planet {
    static let touched = "planet_touched"
}

class planetTest: SKSpriteNode, InteractiveNode {


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
        
        
        
        
        
        
        
        print("touched planet")
        NotificationCenter.default.post(Notification(name: NSNotification.Name(Planet.touched), object: nil))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        interact()
    }
}
