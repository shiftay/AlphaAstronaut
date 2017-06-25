//
//  GameViewController.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-20.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    static var Player: PlayersShip!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameViewController.Player = PlayersShip()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "WorldView") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
            
            
            
            
            view.autoresizesSubviews = true
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
