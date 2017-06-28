//
//  alphaBtn.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class alphaBtn: SKSpriteNode, InteractiveNode {
    
    func interact() {
        
    }
    
    
    func sceneLoaded() {
        isUserInteractionEnabled = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        interact()
    }
    
    
}
