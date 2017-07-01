//
//  File.swift
//  iOSProject
//
//  Created by Stephen Roebuck on 2017-06-24.
//  Copyright © 2017 See No Evil. All rights reserved.
//

import Foundation




class Quest {
    var questTypes: [String] = ["collect", "deliverPlanet", "deliverSS"]
    var resourceTypes: [String] = ["Oil", "Minerals", "Metal Parts"]
    var planetNames: [String] = [PlanetList.blue, PlanetList.earth, PlanetList.red, PlanetList.yellow, PlanetList.ring]
    var description: String!
    var reward: Int!
    var reputationGain: Int!
//    var faction
    var resourceAmount: Int!
    var resourceType: String!
    var planetName: String!
    var questGiver: String
    var questName: String!
    var questType: String!
    var isCompleted: Bool = false
    
    init(questGiver: String) {
        self.questGiver = questGiver
        createQuest()
        createReward()
    }
    
    func createReward() {
        reward = Int.random(min: 250,max: 800)
        if reward > 500 {
            reputationGain = 10
        } else {
            reputationGain = 5
        }
    }
    
    func createQuest() {
        questType = questTypes[Int.random(min:0, max: questTypes.count - 2)]
        resourceType = resourceTypes[Int.random(min: 0, max: resourceTypes.count - 1)]
        planetName = planetNames[Int.random(min: 0, max: planetNames.count - 1)]
        
        switch questType {
        case "collect":
            description = "You must go to \(planetName) and collect\n \(resourceAmount) \(resourceType). Upon returning \nto \(questGiver) you will recieve your reward."
            questName = "Collect \(resourceType) from \(planetName!)"
        case "deliverSS":
            print("inside DeliverSS")
        case "deliverPlanet":
            description = "You must go to \(planetName!) and deliver this package.\n It will take up your inventory space,\n however they will pay you on arrival."
            questName = "Deliver a package to \(planetName!)"
        default:
            break
        }
        
    }
    
}
