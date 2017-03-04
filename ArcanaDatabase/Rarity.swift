//
//  Rarity.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 2/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Foundation

extension String {
    
    func fixEmptyString(rarity: String) -> String {
        
        switch rarity {
        case "1":
            return "1"
        case "2":
            return "1"
        case "3":
            return "2"
        case "4":
            return "3"
        case "5":
            return "4"
        default:
            return "0"
        }
    }
    
}
