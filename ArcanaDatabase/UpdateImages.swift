//
//  UpdateImages.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 12/6/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation


// Update both images given UID. If one of the URLS are empty, don't update that one only.

func downloadImages(uid: String, imageURL: String, iconURL: String) {
        
    let ref = FIREBASE_REF.child("arcana/\(uid)")

    var images = [String : String]()
    
    print("Processing input...")

    images.updateValue(imageURL, forKey: "main")
    images.updateValue(iconURL, forKey: "icon")
    
    
    for (image, url) in images {
        
        if url != "" {
            
            if image == "main" {
                ref.child("imageURL").setValue(url)
            }
            else {
                ref.child("iconURL").setValue(url)
            }
            
            let url = URL(string: url)
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print("DOWNLOAD \(image) ERROR")
                }
                
                if let data = data {
                    // upload to firebase storage.
                    
                    let arcanaImageRef = STORAGE_REF.child("image/arcana/\(uid)/\(image).jpg")
                    
                    arcanaImageRef.put(NSData(data: data) as Data, metadata: nil) { metadata, error in
                        if (error != nil) {
                            print("ERROR OCCURED WHILE UPLOADING \(image)")
                        } else {
                            print("UPLOADED \(image) FOR \(uid)")
                            
                        }
                    }
                    
                }
                
            })
            task.resume()
            
        }
    }
    
}
