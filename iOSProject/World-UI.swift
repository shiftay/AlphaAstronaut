//
//  World-UI.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-07-02.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

extension World {
    func createGatherBox(HUDsize: CGSize) -> SKSpriteNode {
        let planet = childNode(withName: GameViewController.Player.currentPlanetSelected) as? planetBase
        
        let bg = SKSpriteNode(color: .black, size: (scene?.size)!)
        bg.alpha = 0.90
        bg.zPosition = -10
        bg.position = CGPoint.zero
        bg.name = "bg"
        
        let box = SKSpriteNode(imageNamed: "Overlay")
        box.size =  CGSize(width: HUDsize.width, height: HUDsize.height * 0.5)
        box.zPosition = 52
        box.position = CGPoint.zero
        box.name = "GatherPopup"
        box.addChild(bg)
        

        let quit = SKSpriteNode(imageNamed: "XBtn")
        quit.size = CGSize(width: box.size.width * 0.1, height: box.size.width * 0.1)
        quit.zPosition = 53
        quit.name = "Quit"
        quit.position = CGPoint(x: (0 - box.size.width * 0.5) + quit.size.width,y: (0 + box.size.height * 0.5) - quit.size.height * 0.75)
        box.addChild(quit)
        
        var test: [String] = []
        if (planet?.hasOil)! {
            test.append("Oil")
        }
        if (planet?.hasMetal)! {
            test.append("Metal")
        }
        if (planet?.hasMinerals)! {
            test.append("Minerals")
        }
        test.append("Fuel")
        
        
        for i in 0...(test.count - 1) {
            var resource = SKSpriteNode()
            
            switch test[i] {
            case "Oil":
                resource = SKSpriteNode(imageNamed: "OilBtn")
            case "Metal":
                resource = SKSpriteNode(imageNamed: "MetalBtn")
            case "Minerals":
                resource = SKSpriteNode(imageNamed: "MineralsBtn")
            case "Fuel":
                resource = SKSpriteNode(imageNamed: "Fuel")
            default:
                break
            }

            resource.size = CGSize(width: box.size.width * 0.66, height: box.size.height * 0.15)
            resource.zPosition = 53
            resource.position = CGPoint(x: 0, y: (0 + box.size.height * 0.25) - ((resource.size.height + 15) * CGFloat(i)))
            resource.name = test[i]
            
            
            box.addChild(resource)
        }
        
        return box
    }

    func createInventoryFull(HUDsize: CGSize, Message: String) -> SKSpriteNode {
        let bg = SKSpriteNode(color: .black, size: (scene?.size)!)
        bg.alpha = 0.90
        bg.zPosition = -10
        bg.position = CGPoint.zero
        bg.name = "bg"
        
        let box = SKSpriteNode(imageNamed: "Overlay")
        box.size = CGSize(width: HUDsize.width, height: HUDsize.height * 0.5)
        box.zPosition = 52
        box.position = CGPoint.zero
        box.name = "InvenFull"
        box.addChild(bg)
        
        box.addChild(World.createStringOL(string: Message, characterCount: 10, pos: CGPoint(x: 0, y: 0 + HUDsize.height * 0.1)))
        
        
        let okayInv = SKSpriteNode(imageNamed: "Okay")
        okayInv.size = CGSize(width: box.size.width * 0.66, height: box.size.height * 0.25)
        okayInv.position = CGPoint(x: 0, y: (0 - box.size.height * 0.5) + okayInv.size.height * 0.5 + 20)
        okayInv.zPosition = 53
        okayInv.name = "leaveInv"
        box.addChild(okayInv)
        return box
    }

    func createSellBox(HUDsize: CGSize) -> SKSpriteNode {
        let bg = SKSpriteNode(color: .black, size: (scene?.size)!)
        bg.alpha = 0.90
        bg.zPosition = -10
        bg.position = CGPoint.zero
        bg.name = "bg"
        
        let box = SKSpriteNode(imageNamed: "Overlay")
        box.size = CGSize(width: HUDsize.width * 1.25, height: HUDsize.height * 0.6)
        box.zPosition = 52
        box.position = CGPoint.zero
        box.name = "ShopPopup"
        box.addChild(bg)
        
        let number = SKSpriteNode(imageNamed: "Box")
        number.size = CGSize(width: HUDsize.width * 0.33, height: HUDsize.width * 0.33)
        number.zPosition = 53
        number.position = CGPoint(x: 0, y: 0 + number.size.height * 0.5)
        number.name = "number"
        box.addChild(number)
        
        let text = SKLabelNode(fontNamed: "Arial")
        text.zPosition = 54
        text.verticalAlignmentMode = .center
        text.position = number.position
        text.text = "0"
        text.name = "numText"
        text.fontColor = .black
        text.fontSize = 100
        box.addChild(text)
        
        
        let plus = SKSpriteNode(imageNamed: "Plus")
        plus.size = CGSize(width: HUDsize.width * 0.2, height: HUDsize.width * 0.2)
        plus.zPosition = 53
        plus.position = CGPoint(x: number.position.x + HUDsize.width * 0.35, y: number.position.y)
        plus.name = "plus"
        box.addChild(plus)
        
        let minus = SKSpriteNode(imageNamed: "Minus")
        minus.size = CGSize(width: HUDsize.width * 0.2, height: HUDsize.width * 0.2)
        minus.zPosition = 53
        minus.position = CGPoint(x: number.position.x - HUDsize.width * 0.35, y: number.position.y)
        minus.name = "minus"
        box.addChild(minus)
        
        let maxArea = SKSpriteNode(imageNamed: "Box")
        maxArea.size = CGSize(width: HUDsize.width * 0.35, height: HUDsize.width * 0.15)
        maxArea.zPosition = 53
        maxArea.position = CGPoint(x: 0, y: number.position.y - number.size.height)
        maxArea.name = "maxArea"
        box.addChild(maxArea)
        
        let max = SKSpriteNode(imageNamed: "MAX")
        max.size = CGSize(width: HUDsize.width * 0.15, height: HUDsize.width * 0.1)
        max.zPosition = 53
        max.position = CGPoint(x: plus.position.x, y: maxArea.position.y)
        max.name = "MAX"
        box.addChild(max)
        
        let clear = SKSpriteNode(imageNamed: "Clear")
        clear.size = CGSize(width: HUDsize.width * 0.15, height: HUDsize.width * 0.1)
        clear.zPosition = 53
        clear.position = CGPoint(x: minus.position.x, y: maxArea.position.y)
        clear.name = "CLEAR"
        box.addChild(clear)
        
        let mText = SKLabelNode(fontNamed: "Arial")
        mText.zPosition = 54
        mText.verticalAlignmentMode = .center
        mText.position = maxArea.position
        mText.text = "$0"
        mText.name = "maxText"
        mText.fontColor = .black
        mText.fontSize = 35
        box.addChild(mText)

        let okay = SKSpriteNode(imageNamed: "Okay")
        okay.size = CGSize(width: box.size.width * 0.45, height: box.size.height * 0.2)
        box.addChild(okay)
        okay.position = CGPoint(x: 0 - okay.size.width * 0.5, y: (0 - box.size.height * 0.5) + okay.size.height * 0.7)
        okay.zPosition = 53
        okay.name = "okay"
        
        let cancel = SKSpriteNode(imageNamed: "Cancel")
        cancel.size = CGSize(width: box.size.width * 0.45, height: box.size.height * 0.2)
        box.addChild(cancel)
        cancel.position = CGPoint(x: 0 + cancel.size.width * 0.5, y: (0 - box.size.height * 0.5) + cancel.size.height * 0.7)
        cancel.zPosition = 53
        cancel.name = "cancel"
        
        return box
    }

    func createQuestBox(HUDsize: CGSize, QuestNumber: Int) -> SKSpriteNode {
        let spaceStation = childNode(withName: GameViewController.Player.currentPlanetSelected) as? SpaceStation
        
        let bg = SKSpriteNode(color: .black, size: (scene?.size)!)
        bg.alpha = 0.90
        bg.zPosition = -10
        bg.position = CGPoint.zero
        bg.name = "bg"
        
        let box = SKSpriteNode(imageNamed: "Overlay")
        box.size = CGSize(width: HUDsize.width, height: HUDsize.height * 0.5)
        box.zPosition = 52
        box.position = CGPoint.zero
        box.name = "QuestPopup"
        box.addChild(bg)
        
        
        box.addChild(World.createStringOL(string: (spaceStation?.quests[QuestNumber].description!)!, characterCount: 20, pos: CGPoint(x: 0, y: 0 + box.size.height * 0.25)))
        
        

        
        let okay = SKSpriteNode(imageNamed: "Okay")
        okay.size = CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15)
        box.addChild(okay)
        okay.position = CGPoint(x: 0 - okay.size.width * 0.5, y: (0 - box.size.height * 0.5) + okay.size.height * 0.5)
        okay.zPosition = 53
        okay.name = "okay\(QuestNumber)"
        
        let cancel = SKSpriteNode(imageNamed: "Cancel")
        cancel.size = CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15)
        box.addChild(cancel)
        cancel.position = CGPoint(x: 0 + cancel.size.width * 0.5, y: (0 - box.size.height * 0.5) + cancel.size.height * 0.5)
        cancel.zPosition = 53
        cancel.name = "cancel\(QuestNumber)"
        
        
        
        return box
    }

}
