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
        
        
        let quit = SKSpriteNode(color: .white, size: CGSize(width: box.size.width * 0.1, height: box.size.width * 0.1))
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
            let resource = SKSpriteNode(color: .white, size: CGSize(width: box.size.width * 0.66, height: box.size.height * 0.15))
            resource.zPosition = 53
            resource.position = CGPoint(x: 0, y: (0 + box.size.height * 0.25) - ((resource.size.height + 15) * CGFloat(i)))
            resource.name = test[i]
            
            let resText = SKLabelNode(fontNamed: "Arial")
            resText.position = resource.position
            resText.zPosition = 54
            resText.text = test[i]
            resText.fontColor = .black
            resText.fontSize = 25
            resText.name = test[i]
            resText.verticalAlignmentMode = .center
            resText.horizontalAlignmentMode = .center
            
            box.addChild(resource)
            box.addChild(resText)
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
        
        box.addChild(World.createStringOL(string: Message, characterCount: 10))
        
//        let label = SKLabelNode(fontNamed: "Arial")
//        label.position = CGPoint.zero
//        label.text = Message
//        label.zPosition = 53
//        label.fontColor = .black
//        label.fontSize = 50
//        box.addChild(label)
        
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
        
        let box = SKSpriteNode(color: .white, size: CGSize(width: HUDsize.width, height: HUDsize.height * 0.5))
        box.zPosition = 52
        box.position = CGPoint.zero
        box.name = "ShopPopup"
        box.addChild(bg)
        
        let number = SKSpriteNode(color: .red, size: CGSize(width: HUDsize.width * 0.33, height: HUDsize.width * 0.33))
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
        text.fontColor = .white
        text.fontSize = 100
        box.addChild(text)
        
        
        let plus = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.1, height: HUDsize.width * 0.1))
        plus.zPosition = 53
        plus.position = CGPoint(x: number.position.x + HUDsize.width * 0.35, y: number.position.y)
        plus.name = "plus"
        box.addChild(plus)
        
        let minus = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.1, height: HUDsize.width * 0.1))
        minus.zPosition = 53
        minus.position = CGPoint(x: number.position.x - HUDsize.width * 0.35, y: number.position.y)
        minus.name = "minus"
        box.addChild(minus)
        
        let maxArea = SKSpriteNode(color: .black, size: CGSize(width: HUDsize.width * 0.35, height: HUDsize.width * 0.15))
        maxArea.zPosition = 53
        maxArea.position = CGPoint(x: 0, y: number.position.y - number.size.height)
        maxArea.name = "maxArea"
        box.addChild(maxArea)
        
        let max = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.15, height: HUDsize.width * 0.1))
        max.zPosition = 53
        max.position = CGPoint(x: plus.position.x, y: maxArea.position.y)
        max.name = "MAX"
        box.addChild(max)
        
        let clear = SKSpriteNode(color: .blue, size: CGSize(width: HUDsize.width * 0.15, height: HUDsize.width * 0.1))
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
        mText.fontColor = .white
        mText.fontSize = 35
        box.addChild(mText)
        
        
        
        let okay = SKSpriteNode(color: .blue, size: CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15))
        box.addChild(okay)
        okay.position = CGPoint(x: 0 - okay.size.width * 0.5, y: (0 - box.size.height * 0.5) + okay.size.height * 0.5)
        okay.zPosition = 53
        okay.name = "okay"
        
        let cancel = SKSpriteNode(color: .purple, size: CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15))
        box.addChild(cancel)
        cancel.position = CGPoint(x: 0 + cancel.size.width * 0.5, y: (0 - box.size.height * 0.5) + cancel.size.height * 0.5)
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
        
        
//        let descText = SKLabelNode(fontNamed: "Arial")
//        descText.position = description.position
//        descText.zPosition = 54
//        descText.fontColor = .black
//        descText.fontSize = 20
//        descText.horizontalAlignmentMode = .center
//        descText.name = "descT"
//        print("\(String(describing: spaceStation?.quests[QuestNumber].description!))")
//        descText.text = spaceStation?.quests[QuestNumber].description!
//        box.addChild(descText)
        
        box.addChild(World.createStringOL(string: (spaceStation?.quests[QuestNumber].description!)!, characterCount: 20, pos: CGPoint(x: 0, y: 0 + box.size.height * 0.25)))
        
        
        //TODO: Setup quest within the description box.
        
        let okay = SKSpriteNode(color: .blue, size: CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15))
        box.addChild(okay)
        okay.position = CGPoint(x: 0 - okay.size.width * 0.5, y: (0 - box.size.height * 0.5) + okay.size.height * 0.5)
        okay.zPosition = 53
        okay.name = "okay\(QuestNumber)"
        
        let cancel = SKSpriteNode(color: .purple, size: CGSize(width: box.size.width * 0.5, height: box.size.height * 0.15))
        box.addChild(cancel)
        cancel.position = CGPoint(x: 0 + cancel.size.width * 0.5, y: (0 - box.size.height * 0.5) + cancel.size.height * 0.5)
        cancel.zPosition = 53
        cancel.name = "cancel\(QuestNumber)"
        
        
        
        return box
    }

}
