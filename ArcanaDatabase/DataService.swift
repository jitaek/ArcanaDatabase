//
//  DataService.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 7/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Firebase

class DataService: NSObject {
    
    static let shared = DataService()
    
    func findLegends() {
        
        ARCANA_REF.observe(.childAdded, with: { snapshot in
            
            let arcanaID = snapshot.key
            if let arcanaDict = snapshot.value as? [String: Any] {
                if let tavern = arcanaDict[ArcanaAttribute.tavern] as? String {
                    if tavern.contains("레전드") {
                        LEGEND_REF.child(arcanaID).setValue(true)
                    }
                }
            }
        })
    }
}
