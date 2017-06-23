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


class ArcanaDatabase: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var iconField: UITextField!
    // let google = "https://www.google.com/searchbyimage?&image_url="
    // let imageURL = "https://cdn.img-conv.gamerch.com/img.gamerch.com/xn--eckfza0gxcvmna6c/149117/20141218143001Q53NTilN.jpg"
    @IBAction func downloadImage(_ sender: Any) {
    }
    let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
    let group = DispatchGroup()
    let loop = DispatchGroup()
    let download = DispatchGroup()
    let arcanaURL = "幸運に導く戦士ニンファ"
    //let dispatch_group = dispatch_group_create()

    var attributeValues = [String]()
    var urls = [String]()
    var arcanaDict = [String : String]()
    var arcanaID: Int?
    var arcanaArray = [Arcana]()
    
    
    @IBAction func updateImages(_ sender: Any) {
        downloadImages(uid: nameField.text!, imageURL: imageField.text!, iconURL: iconField.text!)
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

