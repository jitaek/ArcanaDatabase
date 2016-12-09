//
//  Ability.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 12/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import Firebase



func updateAbility(ability: String) {
    
    let ref = FIREBASE_REF.child("arcana")
    ref.observeSingleEvent(of: .value, with: { snapshot in
        
        for arcana in snapshot.children {
            if let ability1 = ((arcana as! FIRDataSnapshot).value as! NSDictionary)["abilityDesc1"] as? String {
                
                
            }
            
            if let ability2 = ((arcana as! FIRDataSnapshot).value as! NSDictionary)["abilityDesc2"] as? String {
                
            }

            if let kizuna = ((arcana as! FIRDataSnapshot).value as! NSDictionary)["kizunaDesc"] as? String {
                
            }
            
        }
    })
    
}

/*
func findAbilities() {
    
    if let id = self.dict["uid"] {
        if let sD1 = self.dict["skillDesc1"] {
            if sD1.contains("아군") && sD1.contains("공격력") {
                let buffRef = FIREBASE_REF.child("buff/\(id)")
                buffRef.setValue(true)
            }
        }
        if let sD2 = self.dict["skillDesc2"] {
            if sD2.contains("아군") && sD2.contains("공격력") {
                let buffRef = FIREBASE_REF.child("buff/\(id)")
                buffRef.setValue(true)
            }
        }
        if let sD3 = self.dict["skillDesc3"] {
            if sD3.contains("아군") && sD3.contains("공격력") {
                let buffRef = FIREBASE_REF.child("buff/\(id)")
                buffRef.setValue(true)
            }
        }
        
        if let aD1 = self.dict["abilityDesc1"] {
            if aD1.contains("서브") && !aD1.contains("마나를") {
                let abilityRef = FIREBASE_REF.child("subAbility/\(id)")
                abilityRef.setValue(true)
            } else if aD1.contains("마나를") && aD1.contains("시작") {
                let abilityRef = FIREBASE_REF.child("manaAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD1.contains("마나 슬롯") && aD1.contains("속도") && !aD1.contains("이동 속도") {
                let abilityRef = FIREBASE_REF.child("manaSlotAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD1.contains("마나 슬롯 때") || (aD1.contains("마나") && aD1.contains("쉽게한다")) {
                let abilityRef = FIREBASE_REF.child("manaChanceAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD1.contains("보물") {
                let abilityRef = FIREBASE_REF.child("treasureAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD1.contains("골드") {
                let abilityRef = FIREBASE_REF.child("goldAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD1.contains("경험치") {
                let abilityRef = FIREBASE_REF.child("expAbility/\(id)")
                abilityRef.setValue(true)
            }
            
            if aD1.contains("필살기") {
                let abilityRef = FIREBASE_REF.child("skillUpAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD1.contains("AP") {
                let abilityRef = FIREBASE_REF.child("apRecoverAbility/\(id)")
                abilityRef.setValue(true)
            }
            
            
        }
        if let aD2 = self.dict["abilityDesc2"] {
            if aD2.contains("서브") && !aD2.contains("마나를") {
                let abilityRef = FIREBASE_REF.child("subAbility/\(id)")
                abilityRef.setValue(true)
            } else if aD2.contains("마나를") && aD2.contains("시작"){
                let abilityRef = FIREBASE_REF.child("manaAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD2.contains("마나 슬롯") && aD2.contains("속도") && !aD2.contains("이동 속도") {
                let abilityRef = FIREBASE_REF.child("manaSlotAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD2.contains("마나 슬롯 때") || (aD2.contains("마나") && aD2.contains("쉽게한다")) {
                let abilityRef = FIREBASE_REF.child("manaChanceAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD2.contains("보물") {
                let abilityRef = FIREBASE_REF.child("treasureAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD2.contains("골드") {
                let abilityRef = FIREBASE_REF.child("goldAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD2.contains("경험치") {
                let abilityRef = FIREBASE_REF.child("expAbility/\(id)")
                abilityRef.setValue(true)
            }
            
            if aD2.contains("필살기") {
                let abilityRef = FIREBASE_REF.child("skillUpAbility/\(id)")
                abilityRef.setValue(true)
            }
            if aD2.contains("AP") {
                let abilityRef = FIREBASE_REF.child("apRecoverAbility/\(id)")
                abilityRef.setValue(true)
            }
        }
        if let k = self.dict["kizunaDesc"] {
            if k.contains("서브") && !k.contains("마나를") {
                let kizunaRef = FIREBASE_REF.child("subKizuna/\(id)")
                kizunaRef.setValue(true)
            } else if k.contains("마나를") && k.contains("시작") {
                let kizunaRef = FIREBASE_REF.child("manaKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            if k.contains("마나 슬롯") {
                let kizunaRef = FIREBASE_REF.child("manaChanceKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            if k.contains("보물") {
                let kizunaRef = FIREBASE_REF.child("treasureKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            if k.contains("골드") {
                let kizunaRef = FIREBASE_REF.child("goldKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            if k.contains("경험치") {
                let kizunaRef = FIREBASE_REF.child("expKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            
            if k.contains("필살기") {
                let kizunaRef = FIREBASE_REF.child("skillUpKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            
            if k.contains("보스") {
                let kizunaRef = FIREBASE_REF.child("bossWaveKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            if (k.contains("암흑") || k.contains("어둠")) && k.contains("않는다") {
                let kizunaRef = FIREBASE_REF.child("darkImmuneKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            if k.contains("독") && k.contains("않는다") {
                let kizunaRef = FIREBASE_REF.child("poisonImmuneKizuna/\(id)")
                kizunaRef.setValue(true)
            }
            if (k.contains("슬로우") || k.contains("스러운")) && (k.contains("않는다") || k.contains("안고")) {
                let kizunaRef = FIREBASE_REF.child("slowImmuneKizuna/\(id)")
                kizunaRef.setValue(true)
            }
        }
    }
    
}*/
