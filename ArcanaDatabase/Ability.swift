//
//  Ability.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 12/9/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import Firebase

enum AbilityType {
    case Ability
    case Kizuna
}
class Ability {
    
    private let KR: String
    private let EN: String
    
    init(kr: String, en: String) {
        self.KR = kr
        self.EN = en

    }
    
    func getKR() -> String {
        return KR
    }
    
    func getEN() -> String {
        return EN
    }
    

    
    
}

class Gold: Ability {
    init() {
        super.init(kr: "골드", en: "gold")
    }
}

class Experience: Ability {
    init() {
        super.init(kr: "경험치", en: "exp")
    }
}

class APRecover: Ability {
    init() {
        super.init(kr: "AP", en: "apRecover")
    }
}

protocol Conditions {
 
    
}

extension Conditions {
    var immune: String { return "않는다" }
}
// 상태 이상
/*
 if (k.contains("암흑") || k.contains("어둠")) && k.contains("않는다") {
 let kizunaRef = FIREBASE_REF.child("darkImmuneKizuna/\(id)")
 kizunaRef.setValue(true)
 }
 if k.contains("독") && k.contains("않는다") {
 let kizunaRef = FIREBASE_REF.child("poisonImmuneKizuna/\(id)")
 kizunaRef.setValue(true)
 }
 if (k.contains("슬로우") || k.contains("스러운")) && (k.contains("않는다") || k.contains("안고")) {
*/

class DarkImmune: Ability, Conditions {
    
    init() {
        super.init(kr: "암흑", en: "darkImmune")
    }
}

class SlowImmune: Ability {
    init() {
        super.init(kr: "슬로우", en: "slowImmune")
    }
}

class PoisonImmune: Ability {
    init() {
        super.init(kr: "독", en: "poisonImmune")
    }
}

class CurseImmune: Ability {
    init() {
        super.init(kr: "저주", en: "curseImmune")
    }
}

class WeakImmune: Ability {
    init() {
        super.init(kr: "쇠약", en: "weakImmune")
    }
}

class SkeletonImmune: Ability {
    init() {
        super.init(kr: "백골", en: "skeletonImmune")
    }
}

class StunImmune: Ability {
    init() {
        super.init(kr: "다운", en: "stunImmune")
    }
}

class FrostImmune: Ability {
    init() {
        super.init(kr: "동결", en: "frostImmune")
    }
}

class SealImmune: Ability {
    init() {
        super.init(kr: "봉인", en: "sealImmune")
    }
}


// 지형 특효
class WasteLand: Ability {
    init() {
        super.init(kr: "황무지", en: "wastelands")
    }
}

class Forest: Ability {
    init() {
        super.init(kr: "숲", en: "forest")
    }
}

class Cavern: Ability {
    init() {
        super.init(kr: "동굴", en: "cavern")
    }
}

class Desert: Ability {
    init() {
        super.init(kr: "사막", en: "desert")
    }
}

class Snow: Ability {
    init() {
        super.init(kr: "설산", en: "snow")
    }
}

class Urban: Ability {
    init() {
        super.init(kr: "도시", en: "urban")
    }
}

class Water: Ability {
    init() {
        super.init(kr: "해변", en: "water")
    }
}

class Night: Ability {
    init() {
        super.init(kr: "야간", en: "night")
    }
}

// 종족 특효 
//protocol AbilityType {
//    
//    private let attack: String
//    private let defense: String
//}

class Insect: Ability {
    
    private let attackKR = "공격력 증가"
    private let defenseKR = "방어력 증가"
    
    init() {
        super.init(kr: "벌레", en: "insect")
    }
    
    func getAttack() -> String {
        return attackKR
    }
    
    func getDefense() -> String {
        return defenseKR
    }
}

// HP 회복

class LifeSteal: Ability {
    
    private let matches = ["준 데미지 량", "HP", "회복"]
    
    init() {
        super.init(kr: "준 데미지 량", en: "insect")
    }
    
    func getMatches() -> [String] {
        return matches
    }
}

// Checks both abilities and kizuna to see if arcana includes this ability.
func updateAbility(ability: Ability) {
    
    
    let arcanaRef = FIREBASE_REF.child("arcana")
    let abilityEN = ability.getEN()
//    let abilityType = ability.getType()
    
    print("Looking up arcana with \(ability.getKR())...")
    
    
    arcanaRef.observeSingleEvent(of: .value, with: { snapshot in
        
        for child in snapshot.children {
            
            let arcana = (child as! FIRDataSnapshot).value as! NSDictionary
            
            let uid = arcana["uid"] as! String
            
            if let ability1 = arcana["abilityDesc1"] as? String {
                
                if ability1.contains(ability.getKR()) {
                    
                    let abilityRef = FIREBASE_REF.child(abilityEN + "Ability/" + uid)
                    abilityRef.setValue(true)
                    
                }
            }
            
            if let ability2 = arcana["abilityDesc2"] as? String {
                
                if ability2.contains(ability.getKR()) {
                    
                    let abilityRef = FIREBASE_REF.child(abilityEN + "Ability/" + uid)
                    abilityRef.setValue(true)
                    
                }
            }

            if let kizuna = arcana["kizunaDesc"] as? String {
                
                if kizuna.contains(ability.getKR()) {
                    
                    let abilityRef = FIREBASE_REF.child(abilityEN + "Kizuna/" + uid)
                    abilityRef.setValue(true)
                    
                }
            }
            
        }
        
        print("Finished finding arcana with \(ability.getKR())")
    })
    
}

// Takes in extra conditions
func updateAbility(ability: Ability, conditions: Bool) {
    
    
    let arcanaRef = FIREBASE_REF.child("arcana")
    let abilityEN = ability.getEN()
    //    let abilityType = ability.getType()
    
    print("Looking up arcana with \(ability.getKR())...")
    
    
    let cond2 = "qwefqwefwqe"
    let cond3 = "않는다"
    
    
    arcanaRef.observeSingleEvent(of: .value, with: { snapshot in
        
        for child in snapshot.children {
            
            let arcana = (child as! FIRDataSnapshot).value as! NSDictionary
            
            let uid = arcana["uid"] as! String
            
            if let ability1 = arcana["abilityDesc1"] as? String {
                
                if ((ability1.contains(ability.getKR()) || ability1.contains(cond2)) && ability1.contains(cond3)) {
                    
                    print(uid)
                    print("Ability")
                    print(ability1)
                    
                    let abilityRef = FIREBASE_REF.child(abilityEN + "Ability/" + uid)
                    abilityRef.setValue(true)
                    
                }
            }
            
            if let ability2 = arcana["abilityDesc2"] as? String {
                
                if ((ability2.contains(ability.getKR()) || ability2.contains(cond2)) && ability2.contains(cond3)) {
                    
                    print(uid)
                    print("Ability")
                    print(ability2)
                    let abilityRef = FIREBASE_REF.child(abilityEN + "Ability/" + uid)
                    abilityRef.setValue(true)
                    
                }
            }
            
            if let kizuna = arcana["kizunaDesc"] as? String {
                
                if ((kizuna.contains(ability.getKR()) || kizuna.contains(cond2)) && kizuna.contains(cond3)) {
                    
                    print(uid)
                    print("Kizuna")
                    print(kizuna)
                    let abilityRef = FIREBASE_REF.child(abilityEN + "Kizuna/" + uid)
                    abilityRef.setValue(true)
                    
                }
            }
            
        }
        
        print("Finished finding arcana with \(ability.getKR())")
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
