//
//  UpdateImages.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 12/6/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase

// Update both images given UID. If one of the URLS are empty, don't update that one only.

func downloadImages(uid: String, imageURL: String, iconURL: String, completion: @escaping () -> ()) {
    
    if imageURL == "" && iconURL == "" {
        completion()
        return
    }
    
//    let previewRef = ARCANAPREVIEW_REF.child(uid)
//    let arcanaRef = ARCANA_REF.child(uid)
    let arcanaRef = REVIEW_REF.child(uid)
    var images = [String : String]()
    images.removeAll()
    
    print("Processing input...")

    images.updateValue(imageURL, forKey: "main")
    if (iconURL != "") {
        images.updateValue(iconURL, forKey: "icon")

    }
    
    let dispatchGroup = DispatchGroup()
    
    for (image, url) in images {
        
        dispatchGroup.enter()
        if url != "" {
            
            let url = URL(string: url)
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print("DOWNLOAD \(image) ERROR")
                    completion()
                }
                print("image downloaded.")
                if let data = data {
                    // upload to firebase storage.
                    
                    let arcanaImageRef = STORAGE_REF.child("image/arcana/\(uid)/\(image).jpg")
                    arcanaImageRef.putData(NSData(data: data) as Data, metadata: nil, completion: { (metadata, error) in
                        if (error != nil) {
                            print("ERROR OCCURED WHILE UPLOADING \(image)")
                        } else {
                            print("UPLOADED \(image) FOR \(uid)")
                            if let downloadURL = metadata?.downloadURL()?.absoluteString {
                                if image == "main" {
                                    arcanaRef.child("imageURL").setValue(downloadURL)
                                }
                                else {
                                    arcanaRef.child("iconURL").setValue(downloadURL)
                                }
                                
                            }
                        }
                        dispatchGroup.leave()
                    })
                }
            })
            task.resume()
            
        }
    }
    
    dispatchGroup.notify(queue: .main) {
        completion()
    }
    
}


