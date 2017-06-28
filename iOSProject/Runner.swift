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
    let cameraNode = SKCameraNode()
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var playerLives: Int = 3
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
    
        addChild(player)
        addChild(cameraNode)
        
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        playableRect = CGRect(x: 0, y: cameraRect.minY, width: size.width, height: size.height)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnEnemy()}, SKAction.wait(forDuration: 2.0)])))
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {[weak self] in self?.spawnStaticObjs()}, SKAction.wait(forDuration: 5.0)])))
        
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
                print("WT: \(wrenchTime)")
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
        let enemy = SKSpriteNode(imageNamed: "PauseBtn")
        enemy.name = "enemy"
        enemy.setScale(0.2)
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
        let string = "object\(Int.random(min: 1,max: 3))"
        let obj = SKSpriteNode(imageNamed: string)
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
        resourceCollected += 1
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
            let node = childNode(withName: "\(i)")
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
        
        let yes = SKSpriteNode(imageNamed: "RawBtn")
        yes.size = CGSize(width: testPic.size.width * 0.6 ,height: testPic.size.height / 6)
        yes.position = CGPoint(x: 0, y: 0 - yes.size.height)
        yes.zPosition = 11
        yes.name = "play again"
        
        let no = SKSpriteNode(imageNamed: "RawBtn")
        no.size = CGSize(width: testPic.size.width * 0.6 ,height: testPic.size.height / 6)
        no.position = CGPoint(x: 0, y: 0)
        no.zPosition = 11
        no.name = "play again"
        
        let exit = SKSpriteNode(imageNamed: "RawBtn")
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
        print("skillsbar")
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
                    case "yes":
                        if let hud = scene?.childNode(withName: "HUD")
                        {
                            hud.removeFromParent()
                        }
                    
                        resumeGame()
            
                    case "no":
                        print("pressed no")
                    
                    case "play again":
                        resetGame()
                        if let hud = scene?.childNode(withName: "HUD")
                        {
                            hud.removeFromParent()
                            
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func debugDrawPlayableArea()
    {
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        shape.zPosition = 100
        addChild(shape)
    }
}
