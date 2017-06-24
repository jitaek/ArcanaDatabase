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

enum ArcanaAttribute: String {
    
    case nameKR
    case nicknameKR
    case nameJP
    case nicknameJP
    case rarity
    case group
    case tavern
    case affiliation
    case cost
    case weapon
    
    case kizunaName
    case kizunaCost
    case kizunaDesc
    
    case skillCount
    case skillName1
    case skillMana1
    case skillDesc1
    
    case skillName2
    case skillMana2
    case skillDesc2
    
    case skillName3
    case skillMana3
    case skillDesc3
    
    case abilityName1
    case abilityDesc1
    
    case abilityName2
    case abilityDesc2
    
    case abilityName3
    case abilityDesc3
    
    case partyAbility
    
    case chainStory
}
