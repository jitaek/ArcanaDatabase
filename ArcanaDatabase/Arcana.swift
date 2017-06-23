//
//  Arcana.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//
import Firebase

struct Arcana {
    
    var uid: String
    var nameKR: String
    var nameJP: String
    var iconURL: String?
    var imageURL: String?
    
    init?(snapshot: DataSnapshot) {
        
        //        if let a = snapshot.value as? NSDictionary {
        //            let b = a["uid"] as? String
        //        }
        guard let u = (snapshot.value as? NSDictionary)?["uid"] as? String, let nKR = (snapshot.value as? NSDictionary)?["nameKR"] as? String, let nJP = (snapshot.value as? NSDictionary)?["nameJP"] as? String else {
            print("COULD NOT GET SNAPSHOT OF 1 SKILL ARCANA")
            return nil
        }
        
        uid = u
        nameKR = nKR
        nameJP = nJP
        
        if let iconURL = (snapshot.value as? NSDictionary)?["iconURL"] as? String {
            self.iconURL = iconURL
        }
        if let imageURL = (snapshot.value as? NSDictionary)?["imageURL"] as? String {
            self.imageURL = imageURL
        }
        
    }

    
}

