//
//  File.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation


class Quest {
    var description: String!
    var reward: Int!
    var reputationGain: Int!
//    var faction
    var resourceType: String!
    var planetName: String
    var questGiver: String
    
    
    init(planetTarget: String, questGiver: String) {
        planetName = planetTarget
        self.questGiver = questGiver
    }
}
