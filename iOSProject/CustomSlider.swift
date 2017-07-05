//
//  UISlider.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-23.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class CustomSlider: SKSpriteNode, InteractiveNode {
    
    var currentSize: Int = 1
    var maxSize: CGFloat = 0

    func interact() {
        return
    }
    
    func sceneLoaded() {
        zPosition = 5
        var float: CGFloat = 0.0
        float = CGFloat(GameViewController.Player.ShipStock.currentFuel) / 10.0
        xScale = float
        NotificationCenter.default.addObserver(self, selector: #selector(resize), name: Notification.Name(Timber.resizeSlider), object: nil)
    }
    
    func resize() {
        var float: CGFloat = 0.0
        float = CGFloat(GameViewController.Player.ShipStock.currentFuel) / 10.0
        xScale = float
    }
}
