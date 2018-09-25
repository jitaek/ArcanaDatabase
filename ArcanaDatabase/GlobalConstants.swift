//
//  GlobalConstants.swift
//  Chain
//
//  Created by Jitae Kim on 8/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

//let API_KEY = "AIzaSyBD9eX7ABB0Xu1N6CnSdKL-bnsNF5WgLtc"

let FIREBASE_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()
let ARCANA_REF = FIREBASE_REF.child("arcana")
let ARCANAPREVIEW_REF = FIREBASE_REF.child("arcanaPreview")
let REVIEW_REF = FIREBASE_REF.child("review")
let LEGEND_REF = FIREBASE_REF.child("legend")

let SCREENWIDTH = UIScreen.main.bounds.width
let SCREENHEIGHT = UIScreen.main.bounds.height

// Colors
let WARRIORCOLOR = UIColor(red:1.0, green:0.23, blue:0.19, alpha:1.0)
let KNIGHTCOLOR = UIColor(red:0.0, green:0.48, blue:1.0, alpha:1.0)
let ARCHERCOLOR = UIColor(red:1.0, green:0.8, blue:0.0, alpha:1.0)
let MAGICIANCOLOR = UIColor(red:0.35, green:0.34, blue:0.84, alpha:1.0)
let HEALERCOLOR = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1.0)
let salmonColor = UIColor(red:0.92, green:0.65, blue:0.63, alpha:1.0)
let darkNavyColor = UIColor(red:0.18, green:0.22, blue:0.29, alpha:1.0)
let lightNavyColor = UIColor(red:0.23, green:0.29, blue:0.37, alpha:1.0)
let darkGrayColor = UIColor(red:0.53, green:0.59, blue:0.65, alpha:1.0)
let lightGrayColor = UIColor(red:0.86, green:0.88, blue:0.9, alpha:1.0)
let greenColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1.0)
let lightGreenColor = UIColor(red:0.41, green:0.64, blue:0.51, alpha:1.0)
let textGrayColor = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.0)

enum ArcanaAttribute {
    
    static let arcanaID = "arcanaID"
    static let nameKR = "nameKR"
    static let nicknameKR = "nicknameKR"
    static let nameJP = "nameJP"
    static let nicknameJP = "nicknameJP"
    
    static let rarity = "rarity"
    static let group = "group"
    static let weapon = "weapon"
    static let affiliation = "affiliation"
    
    static let cost = "cost"
    static let tavern = "tavern"
    
    static let kizunaName = "kizunaName"
    static let kizunaCost = "kizunaCost"
    static let kizunaDesc = "kizunaDesc"
    
    static let skillCount = "skillCount"
    static let skillName1 = "skillName1"
    static let skillMana1 = "skillMana1"
    static let skillDesc1 = "skillDesc1"
    
    static let skillName2 = "skillName2"
    static let skillMana2 = "skillMana2"
    static let skillDesc2 = "skillDesc2"
    
    static let skillName3 = "skillName3"
    static let skillMana3 = "skillMana3"
    static let skillDesc3 = "skillDesc3"
    
    static let abilityName1 = "abilityName1"
    static let abilityDesc1 = "abilityDesc1"
    
    static let abilityName2 = "abilityName2"
    static let abilityDesc2 = "abilityDesc2"
    
    static let abilityName3 = "abilityName3"
    static let abilityDesc3 = "abilityDesc3"
    
    static let partyAbility = "partyAbility"
    
    static let chainStory = "chainStory"
    
}
