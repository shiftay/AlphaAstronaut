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
    static let pauseBtn = "pausebtn"
    
    func sceneLoaded()
    {
        guard let scene = scene else
        {
            return
        }

        size = CGSize(width: scene.size.width / 6, height: scene.size.width / 6)
        position = CGPoint(x: size.width * 0.5, y: scene.size.height - size.height * 0.5)
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
        if !Runner.gameState || !Timber.gamePaused
        {
            NotificationCenter.default.post(Notification(name: NSNotification.Name(PauseBtn.pauseBtn), object: nil))
        
            pausedOverlay()
        }
    }
    
    func pausedOverlay()
    {
        guard let scene = scene else
        {
            return
        }
        
        let testPic = SKSpriteNode(imageNamed: "Overlay")
        testPic.size = CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66)
        
        testPic.position = CGPoint.zero
        testPic.zPosition = 10
        
        let bg = SKSpriteNode(color: .black, size: CGSize(width: scene.size.width, height: scene.size.height))
        
        if scene.name == "Runner" {
            bg.position = Runner.cameraPos!
        } else {
            bg.position = CGPoint(x: scene.size.width * 0.5, y: 0 + scene.size.height * 0.5)
        }
        

        bg.zPosition = 4
        bg.alpha = 0.90
        bg.name = "HUD"
        
        let yes = SKSpriteNode(imageNamed: "ReturnToShip")
        yes.size = CGSize(width: testPic.size.width * 0.6 ,height: testPic.size.height / 6)
        yes.position = CGPoint(x: 0, y: 0 - yes.size.height)
        yes.zPosition = 11
        yes.name = "return"
        
        let no = SKSpriteNode(imageNamed: "Resume")
        no.size = CGSize(width: testPic.size.width * 0.6 ,height: testPic.size.height / 6)
        no.position = CGPoint(x: 0, y: 0)
        no.zPosition = 11
        no.name = "resume"
        
        let exit = SKSpriteNode(imageNamed: "Quit")
        exit.size = CGSize(width: testPic.size.width * 0.6 ,height: testPic.size.height / 6)
        exit.position = CGPoint(x: 0, y: yes.position.y - exit.size.height)
        exit.zPosition = 11
        exit.name = "exit"
        
        bg.addChild(no)
        bg.addChild(yes)
        bg.addChild(exit)
        bg.addChild(testPic)
        scene.addChild(bg)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
