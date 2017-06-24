//
//  PauseBtn.swift
//  iOSProject
//
//  Created by Vraj Patel on 2017-06-23.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class PauseBtn: SKSpriteNode, InteractiveNode
{
    //change name for other lane
    static let pauseBtn = "pausebtn"
    
    func sceneLoaded()
    {
        guard let scene = scene else
        {
            return
        }
        
        size = CGSize(width: scene.size.width / 6, height: scene.size.width / 6)
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
        
        position = CGPoint(x: size.width / 2,
                           y: ((scene.camera?.position.y)! + (scene.size.height / 2)) - size.height / 2)
    }
    
    func interact()
    {
        NotificationCenter.default.post(Notification(name: NSNotification.Name(PauseBtn.pauseBtn), object: nil))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
