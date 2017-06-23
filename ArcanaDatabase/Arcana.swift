//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import Firebase

class ArcanaPreview {
    
    private let arcanaID: String
    private let nameKR: String
//    private let nicknameKR: String?
    private let nameJP: String
//    private let nicknameJP: String?
    private let rarity: String
    private let group: String  // Class, 직업
    private let weapon: String
    private let affiliation: String // 소속
    private let numberOfViews = 0
    
    init?(arcanaDict: [String:String]) {
        
        guard let arcanaID = arcanaDict["arcanaID"], let nameKR = arcanaDict["nameKR"], let nameJP = arcanaDict["nameJP"], let rarity = arcanaDict["rarity"], let group = arcanaDict["group"], let weapon = arcanaDict["weapon"], let affiliation = arcanaDict["affiliation"] else { return nil }
        
        self.arcanaID = arcanaID
        self.nameKR = nameKR
        self.nameJP = nameJP
        self.rarity = rarity
        self.group = group
        self.weapon = weapon
        self.affiliation = affiliation
        
    }
    
    func getUID() -> String {
        return arcanaID
    }
    
}

class Arcana: ArcanaPreview {
    
}

