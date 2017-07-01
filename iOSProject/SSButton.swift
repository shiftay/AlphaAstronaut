//
//  Button.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class SSButton: SKSpriteNode, InteractiveNode {
    var descOpen: Bool = false
    
    func interact() {
        guard let scene = scene as? World else {
            return
        }
        if scene.planetTouched || scene.spaceStationTouched {
            return
        }

        if let stationOL = scene.camera?.childNode(withName: "stationOL") as? SKSpriteNode {

            stationOL.run(SKAction.moveTo(x: scene.size.width * 0.5 - stationOL.size.width * 0.5, duration: 0.5))
            alpha = 0.0
        }
    }
    
    func sceneLoaded() {
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !descOpen {
            interact()
        }
    }
    
}
