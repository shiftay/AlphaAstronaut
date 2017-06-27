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
        
        size = CGSize(width: (scene.size.width * 0.33) * 0.33, height: scene.size.height * 0.25)
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
        if !Runner.gameState
        {
            NotificationCenter.default.post(Notification(name: NSNotification.Name(Skills.skilllayout), object: nil))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
