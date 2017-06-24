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

