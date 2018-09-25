//
//  ArcanaDatabase.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//


import UIKit
import Kanna
import SwiftyJSON
import Firebase
import Foundation


class ArcanaUploadViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var iconField: UITextField!

    var arcanaDict = [String : String]()
    
    @IBAction func downloadArcana(_ sender: Any) {
        
        guard let arcanaURL = URL(string: nameField.text!) else { return }
        
        let uploader = ArcanaUploader.uploader
        uploader.parseArcana(arcanaURL: arcanaURL, mainImage: nil, profileImage: nil) { (error, arcana) in
            
            // upload images
            
            if let arcanaID = arcana?.getUID() {
                downloadImages(uid: arcanaID, imageURL: self.imageField.text!, iconURL: self.iconField.text!, completion: {
                    
                    DispatchQueue.main.async {
                        let reviewVC = ReviewViewController(arcanaID: arcanaID)
                        self.navigationController?.pushViewController(reviewVC, animated: true)
                    }
                    
                })
            }
                        
        }
        
    }
    
    @IBAction func updateImages(_ sender: Any) {
        downloadImages(uid: nameField.text!, imageURL: imageField.text!, iconURL: iconField.text!, completion: {
            
            DispatchQueue.main.async {
                self.nameField.text = nil
                self.imageField.text = nil
                self.iconField.text = nil
            }
            
        })
    }
    
    func login() {
    
        Auth.auth().signIn(withEmail: "test@gmail.com", password: "test123") { (user, error) in
            if error != nil {
                print("could not login")
            }
            else {
                print("logged in!")

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
        nameField.delegate = self
        imageField.delegate = self
        iconField.delegate = self
//        downloadImageURLS()
//        DataService.shared.findLegends()
    }
    
    
    
    func downloadImageURLS() {
        
        ARCANA_REF.observe(.childAdded, with: { snapshot in
            
            let arcanaID = snapshot.key
            
            STORAGE_REF.child("image/arcana").child(arcanaID).child("icon.jpg").downloadURL { (URL, error) -> Void in
                
                if error != nil {
                    
                }
                else if let url = URL {
                    ARCANA_REF.child(arcanaID).child("iconURL").setValue(url.absoluteString)
                }
            }
            
            STORAGE_REF.child("image/arcana").child(arcanaID).child("main.jpg").downloadURL { (URL, error) -> Void in
                if error != nil {
                    
                }
                else if let url = URL {
                    ARCANA_REF.child(arcanaID).child("imageURL").setValue(url.absoluteString)
                }
            }
            
            
        })
    }

    func moveAbilityRefs() {
        let ref = FIREBASE_REF
        ref.observe(.childAdded, with: { snapshot in
            if snapshot.key.contains("Ability") || snapshot.key.contains("Kizuna") {
                
                let newAbilityDict: [String : Any] = [snapshot.key : snapshot.value!]
                let newAbilityRef = ref.child("ability")
                
                newAbilityRef.updateChildValues(newAbilityDict)
                
            }
        })
    }
}

