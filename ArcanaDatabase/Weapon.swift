//
//  Weapon.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 12/8/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation

enum Weapon {
    
    enum sword {
        static let KR = "검"
        static let JP = "斬"
    }
    
    enum blunt {
        static let KR = "봉"
        static let JP = "打"
    }
    
    enum spear {
        static let KR = "창"
        static let JP = "突"
    }
    
    enum bow {
        static let KR = "궁"
        static let JP = "弓"
    }
    
    enum wand {
        static let KR = "마"
        static let JP = "魔"
    }
    
    enum heal {
        static let KR = "성"
        static let JP = "聖"
    }
    
    enum fist {
        static let KR = "권"
        static let JP = "拳"
    }
    
    enum gun {
        static let KR = "총"
        static let JP = "銃"
    }
    
    enum rifle {
        static let KR = "저"
        static let JP = "狙"
    }
}

func getWeaponJPKR(_ string: String) -> String {
    
    let weaponsJP = [Weapon.sword.JP, Weapon.blunt.JP, Weapon.spear.JP, Weapon.bow.JP, Weapon.wand.JP, Weapon.heal.JP, Weapon.fist.JP, Weapon.gun.JP, Weapon.rifle.JP]
    let weaponsKR = [Weapon.sword.KR, Weapon.blunt.KR, Weapon.spear.KR, Weapon.bow.KR, Weapon.wand.KR, Weapon.heal.KR, Weapon.fist.KR, Weapon.gun.KR, Weapon.rifle.KR]
    

    for (index, weapon) in weaponsJP.enumerated() {
        
        if string.contains(weapon) {
            return weaponsKR[index]
        }
        
    }
    
    print("didn't find weapon")
    return ""
    
}
