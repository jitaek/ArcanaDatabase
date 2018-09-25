//
//  UpdateTranslations.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 2/16/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Foundation

func translateWaveUp() {
    let ref = FIREBASE_REF.child("arcana")
    ref.observe(.childAdded, with: { snapshot in
        
        let arcanaID = snapshot.key
        var arcanaDict = [String : String]()
        
        if let arcanaData = snapshot.value as? [String : AnyObject] {
            
            if let ability1 = arcanaData["abilityDesc1"] as? String {
                let abilityDesc1 = ability1.replacingOccurrences(of: "進むたび", with: "진행될때마다")
                arcanaDict.updateValue(abilityDesc1, forKey: "abilityDesc1")
            }
            if let ability2 = arcanaData["abilityDesc2"] as? String {
                let abilityDesc2 = ability2.replacingOccurrences(of: "進むたび", with: "진행될때마다")
                arcanaDict.updateValue(abilityDesc2, forKey: "abilityDesc2")
            }
            if let kizuna = arcanaData["kizunaDesc"] as? String {
                let kizunaDesc = kizuna.replacingOccurrences(of: "進むたび", with: "진행될때마다")
                arcanaDict.updateValue(kizunaDesc, forKey: "kizunaDesc")
            }
        }
        
        
        for _ in arcanaDict {
            
            let arcanaRef = FIREBASE_REF.child("arcana").child(arcanaID)
            arcanaRef.updateChildValues(arcanaDict)
        }

    })
}
