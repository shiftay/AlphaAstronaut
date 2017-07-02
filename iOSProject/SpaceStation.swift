//
//  SpaceStation.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-28.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import SpriteKit

enum SSDesc {
    static let alpha = "Hello this is alpha"
    static let beta = "Hello this is beta"
}



class SpaceStation: SKSpriteNode, InteractiveNode {
    var quests: [Quest] = []
    // all rates are multipliers
    let fuelRate: CGFloat = 2.0
    // buyRates
    var oilRate: CGFloat = 100.0
    var mineralRate: CGFloat = 50.0
    var metalRate: CGFloat = 10.0
    // sellRates
    var oilSell: CGFloat = 300.0
    var mineralSell: CGFloat = 150.0
    var metalSell: CGFloat = 30.0
    
    
    var descOpen: Bool = false
    

    func sceneLoaded() {}
    
    func interact() {}
    
    func openInventory(name: String) {
        guard let scene = scene else {
            return
        }
        
        let testPic = SKSpriteNode(color: .green, size: CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66))
        testPic.position = World.cameraPos!
        testPic.zPosition = 10
        testPic.name = "HUD"
        // yes / no == quest / shop
        let yes = SKSpriteNode(color: .blue, size: CGSize(width: testPic.size.width * 0.5, height: testPic.size.height / 8))
        yes.position = CGPoint(x: 0 - yes.size.width * 0.5, y: (0 + testPic.size.height * 0.5) - yes.size.height * 0.5)
        yes.zPosition = 11
        yes.name = "Shop"
        
        let no = SKSpriteNode(color: .purple, size: CGSize(width: testPic.size.width * 0.5, height: testPic.size.height / 8))
        no.position = CGPoint(x: 0 + yes.size.width * 0.5, y: (0 + testPic.size.height * 0.5) - yes.size.height * 0.5)
        no.zPosition = 11
        no.name = "Quest"
        
        
        let leave = SKSpriteNode(color: .white, size: CGSize(width: testPic.size.width * 0.5, height: testPic.size.height * 0.1))
        leave.zPosition = 11
        leave.position = CGPoint(x: 0, y: (0 - testPic.size.height * 0.5) + leave.size.height * 0.5)
        leave.name = "Leave"
        
        testPic.addChild(leave)
        testPic.addChild(generateShopPage(HUDSize: testPic.size, halfSize: yes.size))
        testPic.addChild(no)
        testPic.addChild(yes)
        scene.addChild(testPic)
        
    }
    
    func openDesc(name: String) {
        guard let scene = scene else {
            return
        }
        
        descOpen = true
        
        let testPic = SKSpriteNode(color: .green, size: CGSize(width: scene.size.width * 0.75, height: scene.size.height * 0.66))
        
        testPic.position = World.cameraPos!
        testPic.zPosition = 10
        testPic.name = "HUD"
        
        let yes = SKSpriteNode(color: .blue, size: CGSize(width: testPic.size.width * 0.5, height: testPic.size.height * 0.25))
        yes.position = CGPoint(x: 0 - yes.size.width * 0.5, y: (0 - testPic.size.height * 0.5) + yes.size.height * 0.5)
        yes.zPosition = 11
        yes.name = "yes"
        
        let no = SKSpriteNode(color: .purple, size: CGSize(width: testPic.size.width * 0.5, height: testPic.size.height * 0.25))
        no.position = CGPoint(x: 0 + yes.size.width * 0.5, y: (0 - testPic.size.height * 0.5) + yes.size.height * 0.5)
        no.zPosition = 11
        no.name = "no"
        
        testPic.addChild(no)
        testPic.addChild(yes)
        scene.addChild(testPic)
    }
    
    func randomizeRates() {
        let multiplier = CGFloat.random(min: 0.75, max: 1.5)
        print("\(multiplier)")
        
        oilRate *= multiplier
        mineralRate *= multiplier
        metalRate *= multiplier
    }
    
    func randomizeSell() {
        let multiplier = CGFloat.random(min: 0.5, max: 1)
        print("\(multiplier)")
        
        oilSell *= multiplier
        mineralSell *= multiplier
        metalSell *= multiplier
    }
    
    func generateShopPage(HUDSize: CGSize, halfSize: CGSize) -> SKSpriteNode {
        let shopPage = SKSpriteNode()
        shopPage.position = CGPoint.zero
        shopPage.name = "ShopPage"
        shopPage.zPosition = 11
        
        for i in 1...4 {
            
            let color: UIColor!
            if i == 1 {
                color = .red
            } else {
                color = .yellow
            }
            
            
            let buy2 = SKSpriteNode(color: color, size: CGSize(width: HUDSize.width * 0.33, height: HUDSize.height / 8))
            buy2.position = CGPoint(x: 0 - halfSize.width * 0.5, y: (0 + HUDSize.height * 0.15) - ((buy2.size.height + 10) * CGFloat(i-1)))
            buy2.zPosition = 11
            buy2.name = "buy\(i)"
            
            
            shopPage.addChild(buy2)
        }
        
        
        for i in 1...3 {
            
            let color: UIColor!
            if i == 1 {
                color = .red
            } else {
                color = .yellow
            }
            
            
            let buy2 = SKSpriteNode(color: color, size: CGSize(width: HUDSize.width * 0.33, height: HUDSize.height / 8))
            buy2.position = CGPoint(x: 0 + halfSize.width * 0.5, y: (0 + HUDSize.height * 0.15) - ((buy2.size.height + 10) * CGFloat(i-1)))
            buy2.zPosition = 11
            buy2.name = "sell\(i)"
            
            
            shopPage.addChild(buy2)
        }
        
        return shopPage
    }
    
    func generateQuestPage(HUDSize: CGSize, halfSize: CGSize) -> SKSpriteNode {
        let questPage = SKSpriteNode()
        questPage.position = CGPoint.zero
        questPage.name = "QuestPage"
        questPage.zPosition = 11
        
        for i in 1...2 {
            
            let color: UIColor!
            if i == 1 {
                color = .cyan
            } else {
                color = .orange
            }
            
            
            let buy2 = SKSpriteNode(color: color, size: CGSize(width: HUDSize.width * 0.66, height: HUDSize.height / 8))
            buy2.position = CGPoint(x: 0, y: ((0 + HUDSize.height * 0.1 )) - ((buy2.size.height + 25) * CGFloat(i-1)))
            buy2.zPosition = 11
            buy2.name = "quest\(i)"
            
            let text = SKLabelNode(fontNamed: "Arial")
            text.name = "quest\(i)"
            text.position = buy2.position
            text.zPosition = 12
            text.fontSize = 20
            text.verticalAlignmentMode = .center
            text.fontColor = .black
            text.text = quests[i-1].questName
            
            questPage.addChild(text)
            questPage.addChild(buy2)
        }
        
        return questPage
    }
    
    func createQuests() {
        if quests.count > 0 {
            quests.removeAll()
        }
        
        for i in 0...1 {
            quests.insert(Quest(questGiver: self.name!), at: i)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !descOpen {
            interact()
        }
    }
}
