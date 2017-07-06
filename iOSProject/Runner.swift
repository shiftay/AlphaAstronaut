//
//  Runner.swift
//  iOSProject
//
//  Created by Vraj Patel on 2017-06-22.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

class Runner: SKScene
{
    static let scale = "scale"
    static let movedCamera = "moved"
    static var cameraPos: CGPoint?
    static var fullHP: Bool = true
    static var gameState: Bool = false
    static var useWrench: Bool = false
    var gameOver: Bool = false
    var wrenchTime: TimeInterval = 0
    var timerStarted: Bool = false
    let wrenchDelay: Double = 15
    var currentPlayerPos: Int = 0
    {
        didSet
        {
            movePlayer()
        }
    }
    let player = SKSpriteNode(imageNamed: "Spaceship")
    let cameraMovePointsPerSec = 200.0
    let maxCollected: Int = 100
    let cameraNode = SKCameraNode()
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var playerLives: Int = 0
    {
        didSet
        {
            livesChanged()
        }
    }
    var resourceCollected: Int = 0
    var playableRect: CGRect!
    let shape = SKShapeNode()
    var cameraRect: CGRect
    {
        let x = cameraNode.position.x - size.width * 0.5
        let y = cameraNode.position.y - size.height * 0.5
        
        return CGRect(
            x: x,
            y: y,
            width: size.width,
            height: size.height)
    }
    
    override func didMove(to view: SKView)
    {
        GameViewController.Player.notOnWorldScene = true
        
        for i in 0...1
        {
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: 0, y: CGFloat(i) * background.size.height)
            background.name = "bg"
            addChild(background)
        }
        
        player.yScale = -1
        player.zPosition = 2
        playerLives = 3
        
        addChild(player)
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        playableRect = CGRect(x: 0, y: cameraRect.minY, width: size.width, height: size.height)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnEnemy()}, SKAction.wait(forDuration: 2.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnStaticObjs()}, SKAction.wait(forDuration: 2.0)])))
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? InteractiveNode {
                eventListenerNode.sceneLoaded()
            }
        })

        NotificationCenter.default.addObserver(self, selector: #selector(movePlayerLeft), name: Notification.Name(LeftBtn.leftLane), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movePlayerMiddle), name: Notification.Name(MiddleBtn.middleLane), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movePlayerRight), name: Notification.Name(RightBtn.rightLane), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pausedGame), name: Notification.Name(PauseBtn.pauseBtn), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(skillsBar), name: Notification.Name(Skills.skilllayout), object: nil)

        setupTrail()
    }

    override func update(_ currentTime: TimeInterval)
    {
        if !Runner.gameState
        {
            if lastUpdateTime > 0
            {
                dt = currentTime - lastUpdateTime
            }
            else
            {
                dt = 0
            }
            lastUpdateTime = currentTime
            moveCamera()
            movePlayer()
            livesDisplay()
            garbageCollector()
            checkCollisions()
            
            if playerLives <= 0 && !gameOver
            {
               gameOverScene()
            }
            
            if !timerStarted && !Runner.useWrench
            {
                wrenchTime = currentTime
                timerStarted = true
            }
            
            if timerStarted
            {
                if wrenchTime + wrenchDelay <= currentTime
                {
                    wrenchAlpha()
                }
            }
            
            if playerLives == 3
            {
                Runner.fullHP = true
            }
            else
            {
                Runner.fullHP = false
            }
        }
    }
    
    func addToCamera(node: SKNode)
    {
        node.removeFromParent()
        cameraNode.addChild(node)
    }
    
    func wrenchAlpha()
    {
        Runner.useWrench = true
        timerStarted = false
        if let wrench = childNode(withName: "Wrench") as? Skills
        {
            wrench.run(SKAction.fadeAlpha(to: 1, duration: 2.0))
        }
    }
    
    func backgroundNode() -> SKSpriteNode
    {
        let bgNode = SKSpriteNode()
        bgNode.anchorPoint = CGPoint.zero
        bgNode.name = "bg"
        
        let bg2 = SKSpriteNode(imageNamed: "bg")
        bg2.anchorPoint = CGPoint.zero
        bg2.position = CGPoint.zero
        bgNode.addChild(bg2)
        
        let bg3 = SKSpriteNode(imageNamed: "bg")
        bg3.anchorPoint = CGPoint.zero
        bg3.position = CGPoint(x: 0, y: bg2.size.height)
        bgNode.addChild(bg3)
        
        bgNode.size = CGSize(width: bg2.size.width,
                             height: bg2.size.height + bg3.size.height)
        
        return bgNode
    }
    
    func moveCamera()
    {
        let backgroundVelocity = CGPoint(x: 0, y: cameraMovePointsPerSec)
        let amountToMove = backgroundVelocity * CGFloat(dt)
        cameraNode.position += amountToMove
        Runner.cameraPos = cameraNode.position
        
        NotificationCenter.default.post(Notification(name: NSNotification.Name(Runner.movedCamera), object: nil))
        
        enumerateChildNodes(withName: "bg")
        { node, _ in
            let background = node as! SKSpriteNode
            
            if background.position.y + background.size.height < self.cameraRect.origin.y
            {
                background.position = CGPoint(x: background.position.x,
                                              y: background.position.y + background.size.height * 2)
            }
        }
    }
    
    func movePlayer()
    {
        guard let scene = scene else
        {
            return
        }
        
        switch currentPlayerPos
        {
        case -1:
            player.position = CGPoint(x: (scene.size.width * 0.33) * 0.5, y: cameraNode.position.y - ((scene.size.height * 0.25) + ((scene.size.height * 0.25) * 0.5)))
        case 0:
            player.position = CGPoint(x: cameraNode.position.x, y: cameraNode.position.y - ((scene.size.height * 0.25) + ((scene.size.height * 0.25) * 0.5)))
        case 1:
            player.position = CGPoint(x: scene.size.width - (scene.size.width * 0.33) * 0.5, y: cameraNode.position.y - ((scene.size.height * 0.25) + ((scene.size.height * 0.25) * 0.5)))
        default:
            break
        }
    }
    
    func spawnEnemy()
    {
        let enemy = SKSpriteNode(imageNamed: "Enemy")
        enemy.name = "enemy"
        enemy.setScale(0.75)
        enemy.position = CGPoint(x: CGFloat.random(min: cameraRect.minX + enemy.size.width * 0.5,
                                                   max: cameraRect.maxX - enemy.size.width * 0.5),
                                 y: cameraRect.maxY + enemy.size.height * 0.5)
        enemy.zPosition = 2
        addChild(enemy)
        
        let actionMove = SKAction.moveTo(y: cameraRect.minY - enemy.size.height * 0.5, duration: 2.0)
        
        let actionRemove = SKAction.removeFromParent()
        
        enemy.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    func spawnStaticObjs()
    {
        let obj = SKSpriteNode(imageNamed: GameViewController.Player.planetResources)
        obj.setScale(2)
        obj.name = "object"
        obj.position = CGPoint(x: CGFloat.random(min: cameraRect.minX + obj.size.width * 0.5,
                                                 max: cameraRect.maxX - obj.size.width * 0.5),
                               y: cameraRect.maxY + obj.size.height * 0.5)
        obj.zPosition = 2
        addChild(obj)
    }
    
    func playerHit(enemy: SKSpriteNode)
    {
        playerLives -= 1
        enemy.removeFromParent()
    }
    
    func playerHit(obj: SKSpriteNode)
    {
        if GameViewController.Player.ShipStock.spaceLeft() > 0
        {
            switch GameViewController.Player.planetResources
            {
            case "Oil":
                GameViewController.Player.currentOil += 1
            case "Metal":
                GameViewController.Player.currentMetalParts += 1
            case "Minerals":
                GameViewController.Player.currentMinerals += 1
            default:
                break
            }
            
            NotificationCenter.default.post(Notification(name: NSNotification.Name(Runner.scale), object: nil))
        }
        
        obj.removeFromParent()
    }
    
    func checkCollisions()
    {
        var hitEnemies: [SKSpriteNode] = []
        enumerateChildNodes(withName: "enemy"){node, _ in
            let enemy = node as! SKSpriteNode
            if enemy.frame.intersects(self.player.frame)
            {
                hitEnemies.append(enemy)
            }
        }
        
        for enemy in hitEnemies
        {
            playerHit(enemy: enemy)
        }
        
        var hitObjs: [SKSpriteNode] = []
        enumerateChildNodes(withName: "object"){node, _ in
            let obj = node as! SKSpriteNode
            if obj.frame.intersects(self.player.frame)
            {
                hitObjs.append(obj)
            }
        }
        
        for obj in hitObjs
        {
            playerHit(obj: obj)
        }
    }
    
    func garbageCollector()
    {
        enumerateChildNodes(withName: "object"){node, _ in
            let obj = node as! SKSpriteNode
            
            if obj.position.y < (self.cameraRect.minY - obj.size.height)
            {
                obj.removeFromParent()
            }
        }
    }
    
    func livesDisplay()
    {
        guard let scene = scene else
        {
            return
        }
        
        for i in 1...3
        {
            let node = childNode(withName: "\(i)") as? SKSpriteNode
            node?.setScale(0.75)
            node?.position = CGPoint(x: (scene.size.width - ((node?.size.width)! * 0.5)) - (node?.size.width)! * CGFloat(i - 1),
                                     y: ((scene.camera?.position.y)! + (scene.size.height / 2)) - (node?.size.height)!)
            node?.zPosition = 3
            //TODO: Align top-right based of i and their width
        }
        
    }
    
    func livesChanged()
    {
        for i in 1...3
        {
            let node = childNode(withName: "\(i)") as? SKSpriteNode
            
            if playerLives == 0
            {
                node?.alpha = 0
            }
            else if playerLives == 3
            {
                node?.alpha = 1
            }
            else if playerLives == 2 && i == 1
            {
                node?.alpha = 0
            }
            else if playerLives == 1 && i == 1 || playerLives == 1 && i == 2
            {
                node?.alpha = 0
            }
            else
            {
                node?.alpha = 1
            }
        }
    }
    
    func gameOverScene()
    {
        Runner.gameState = true
        gameOver = true
        
        if hasActions()
        {
            removeAllActions()
        }
        
        enumerateChildNodes(withName: "object"){node, _ in
            let obj = node as! SKSpriteNode
            
            obj.removeFromParent()
        }
        
        guard let scene = scene else
        {
            return
        }
        
        let testPic = SKSpriteNode(imageNamed: "Overlay")
        testPic.size = CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66)
        
        testPic.position = CGPoint.zero
        testPic.zPosition = 10
        
        let bg = SKSpriteNode(color: .black, size: CGSize(width: scene.size.width, height: scene.size.height))
        bg.position =  Runner.cameraPos!
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
        Runner.gameState = false
        timerStarted = false
        Runner.useWrench = false
        gameOver = false
        wrenchTime = 0
        currentPlayerPos = 0
        playerLives = 3
        resourceCollected = 0
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnEnemy()}, SKAction.wait(forDuration: 2.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnStaticObjs()}, SKAction.wait(forDuration: 5.0)])))
    }
    
    func resumeGame()
    {
        Runner.gameState = false
        
        enumerateChildNodes(withName: "enemy"){node, _ in
            if let enemy = node as? SKSpriteNode
            {
                let actionMove = SKAction.moveTo(y: self.cameraRect.minY - enemy.size.height * 0.5, duration: 2.0)
                let actionRemove = SKAction.removeFromParent()

                enemy.run(SKAction.sequence([actionMove, actionRemove]))
            }
        }
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnEnemy()}, SKAction.wait(forDuration: 2.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnStaticObjs()}, SKAction.wait(forDuration: 5.0)])))
    }
    
    func pausedGame()
    {
        Runner.gameState = true
        self.removeAllActions()
        
        enumerateChildNodes(withName: "enemy"){node, _ in
            if let enemy = node as? SKSpriteNode
            {
                enemy.removeAllActions()
            }
        }
    }
    
    func setupTrail()
    {
        let emitter1 = SKEmitterNode(fileNamed: "FireTrail1.sks")!
        let emitter2 = SKEmitterNode(fileNamed: "FireTrail2.sks")!
        emitter1.advanceSimulationTime(3.0)
        emitter2.advanceSimulationTime(3.0)
        emitter1.yScale = -1
        emitter2.yScale = -1
        emitter1.position = CGPoint(x: 0 - player.size.width * 0.20, y: 0 + player.size.height * 0.5)
        emitter2.position = CGPoint(x: 0 + player.size.width * 0.20, y: 0 + player.size.height * 0.5)
        player.addChild(emitter1)
        player.addChild(emitter2)
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
    
    func movePlayerLeft()
    {
        if currentPlayerPos != -1
        {
            currentPlayerPos -= 1
        }
    }
    
    func movePlayerMiddle()
    {
        if currentPlayerPos != 0
        {
            currentPlayerPos = 0
        }
    }
    
    func movePlayerRight()
    {
        if currentPlayerPos != 1
        {
            currentPlayerPos += 1
        }
    }
    
    func skillsBar()
    {
        playerLives += 1
        timerStarted = false
        Runner.useWrench = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first
        {
            if Runner.gameState
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
}
