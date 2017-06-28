//
//  Skills.swift
//  iOSProject
//
//  Created by Vraj Patel on 2017-06-23.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class Skills: SKSpriteNode, InteractiveNode
{
    //change name for other lane
    static let skilllayout = "bar"
    
    func sceneLoaded()
    {
        guard let scene = scene else
        {
            return
        }
        
        alpha = 0.01
        size = CGSize(width: (scene.size.width / 5) * 0.5, height: (scene.size.height * 0.3) * 0.5)
        position = CGPoint(x: scene.size.width - (scene.size.width), y: scene.size.height * 0.5)
        isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(positionBtn), name: Notification.Name(Runner.movedCamera), object: nil)
    }
    
    func positionBtn()
    {
        guard let scene = scene else
        {
            return
        }
        
        position = CGPoint(x: scene.size.width - size.width / 2,
                           y: (scene.camera?.position.y)!)
    }
    
    func interact()
    {
        if !Runner.gameState && Runner.useWrench && !Runner.fullHP
        {
            NotificationCenter.default.post(Notification(name: NSNotification.Name(Skills.skilllayout), object: nil))
            
            alpha = 0.01
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
