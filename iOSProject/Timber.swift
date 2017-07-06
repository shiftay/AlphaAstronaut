//
//  TimberScene.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-20.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit


protocol InteractiveNode {
    func sceneLoaded()
    func interact()
}

class Timber: SKScene {

    var test: CustomSlider?
    static var gamePaused: Bool = false
    static let resizeSlider = "Resize"
    var tree = Tree()
    var playerPosition: Int = 0 {
        didSet {
            if playerPosition == -1 {
                playerSprite.position = leftPos
            } else {
                playerSprite.position = rightPos
            }
        }
    }
    var resourcesNeeded: Int = 0
    var amountCut: Int = 0
    var playerSprite = SKSpriteNode(imageNamed: "Spaceship")
    var keepPlaying: Bool = false
    var leftPos = CGPoint.zero
    var rightPos = CGPoint.zero
    var playable: Bool = true
    var grad: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        leftPos = CGPoint(x: size.width * 0.25, y: playerSprite.size.height * 2)
        rightPos = CGPoint(x: size.width * 0.75, y: playerSprite.size.height * 2)
        GameViewController.Player.notOnWorldScene = true
        resourcesNeeded = GameViewController.Player.ShipStock.maxFuel - GameViewController.Player.ShipStock.currentFuel

        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })
        
        grad = childNode(withName: "grad") as? SKSpriteNode
        
        let topColor = CIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let bottomColor = CIColor(red: 255, green: 255, blue: 255, alpha: 0)
        
        let texture = SKTexture(size: grad.size, color1: topColor, color2: bottomColor, direction: 0)
        texture.filteringMode = .nearest
        grad.texture = texture
        
        
        playerPosition = -1 // left
        addChild(playerSprite)
        tree.BuildTree(scene: scene!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveRight), name: Notification.Name(RightTile.rightTapped), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveLeft), name: Notification.Name(LeftTile.leftTapped), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pausedGame), name: Notification.Name(PauseBtn.pauseBtn), object: nil)
    }
    
    func moveRight() {
        if !playable {
            return
        }

        if playerPosition == -1 {
            // move player object.
            playerPosition = 1
        }
        cutTree()
    }
    
    func moveLeft() {
        if !playable {
            return
        }

        if playerPosition == 1 {
            // move player object.
            playerPosition = -1
        }
        cutTree()
    }
    
    
    func cutTree() {
        if (amountCut + 1) <= resourcesNeeded || keepPlaying{
            if let node = childNode(withName: "tree\(amountCut)") {
                node.removeFromParent()
            }
            
            enumerateChildNodes(withName: "//tree*", using: { node, _ in
                if let node = node as? SKSpriteNode {
                    let x = SKAction.moveTo(y: node.position.y - (node.size.height), duration: 0)
                    node.run(x)
                }
            })

            NotificationCenter.default.post(Notification(name: NSNotification.Name(Timber.resizeSlider), object: nil))
            
            tree.treeLayout.remove(at: 0)
            tree.addToEnd()
            updateTree()

            amountCut += 1
            
            if !keepPlaying {
                GameViewController.Player.ShipStock.currentFuel += 1
            }
            
            
            checkGameOver()
            
        } else {
            playable = false
            gameOverScene()
        }

    }
    
    func checkGameOver() {
        if tree.treeLayout[0] == playerPosition {
            playable = false
            gameOverScene()
        }
    }

    func updateTree() {
        switch tree.treeLayout[tree.treeLayout.count - 1] {
        case -1:
            tree.setLeft(pos: tree.treeLayout.count - 1, scene: (scene)!, test: tree.treeLayout.count + (amountCut))
        case 0:
            tree.setMiddle(pos: tree.treeLayout.count - 1, scene: (scene)!, test: tree.treeLayout.count + (amountCut))
        case 1:
            tree.setRight(pos: tree.treeLayout.count - 1, scene: (scene)!, test: tree.treeLayout.count + (amountCut))
        default:
            break
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first
        {
            if Timber.gamePaused
            {
                if let touchedNode = atPoint(touch.location(in: self)) as? SKSpriteNode
                {
                    switch touchedNode.name!
                    {
                    case "resume":
                        if let hud = scene?.childNode(withName: "HUD")
                        {
                            hud.removeFromParent()
                        }
                        resumeGame()
                        
                    case "exit":
                        print("pressed exit")
                    case "play again":
                        resetGame()
                        if let hud = scene?.childNode(withName: "HUD")
                        {
                            hud.removeFromParent()
                            
                        }
                    case "return":
                        returnToShip()
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func gameOverScene()
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
        bg.position = CGPoint(x: scene.size.width * 0.5, y: 0 + scene.size.height * 0.5)
        bg.zPosition = 4
        bg.alpha = 0.90
        bg.name = "HUD"
        
        let yes = SKSpriteNode(imageNamed: "ReturnToShip")
        yes.size = CGSize(width: testPic.size.width * 0.6 ,height: testPic.size.height / 6)
        yes.position = CGPoint(x: 0, y: 0 - yes.size.height)
        yes.zPosition = 11
        yes.name = "return"
        
        let no = SKSpriteNode(imageNamed: "PlayAgain")
        no.size = CGSize(width: testPic.size.width * 0.6 ,height: testPic.size.height / 6)
        no.position = CGPoint(x: 0, y: 0)
        no.zPosition = 11
        no.name = "play again"
        
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
    
    func resetGame()
    {

    }
    
    func resumeGame()
    {
        Timber.gamePaused = false
    }
    
    func pausedGame()
    {
        Timber.gamePaused = true
    }
    
    func returnToShip()
    {

        if let scene = SKScene(fileNamed: "WorldView")
        {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            
            // Present the scene
            view?.presentScene(scene)
        }
    }
    
}
