//
//  ArcanaDatabase.swift
//  Chain
//
//  Created by Jitae Kim on 8/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//


import UIKit
//import Kanna
//import SwiftyJSON
import Firebase
import Foundation

/*
class ArcanaDatabase: UIViewController {

    // let google = "https://www.google.com/searchbyimage?&image_url="
    // let imageURL = "https://cdn.img-conv.gamerch.com/img.gamerch.com/xn--eckfza0gxcvmna6c/149117/20141218143001Q53NTilN.jpg"
    let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
    let group = DispatchGroup()
    let loop = DispatchGroup()
    let download = DispatchGroup()
    let arcanaURL = "幸運に導く戦士ニンファ"
    //let dispatch_group = dispatch_group_create()

    let priority = DispatchQueue.GlobalQueuePriority.default
    var attributeValues = [String]()
    var urls = [String]()
    var dict = [String : String]()
    var arcanaID: Int?
    
    func handleImage() {
        let ref = FIREBASE_REF.child("arcana")
        ref.observe(.value, with: { snapshot in
            for i in snapshot.children {
                if let imageURL = (i as AnyObject).value?["iconURL"] as? String {
                    //let imageURL = snapshot.value!["iconURL"] as! String
                    let url = URL(string: imageURL)
                    let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print("DOWNLOAD IMAGE ERROR")
                        }
                        
                        if let data = data {
                            print("DOWNLOADED IMAGE!")
                            // upload to firebase storage.
                            
                            let arcanaImageRef = STORAGE_REF.child("image/arcana/\(i.value!["uid"] as! String)/icon.jpg")
                            
                            arcanaImageRef.put(NSData(data: data) as Data, metadata: nil) { metadata, error in
                                if (error != nil) {
                                    print("ERROR OCCURED WHILE UPLOADING IMAGE")
                                    // Uh-oh, an error occurred!
                                } else {
                                    // Metadata contains file metadata such as size, content-type, and download URL.
                                    print("UPLOADED IMAGE.")
                                    //let downloadURL = metadata!.downloadURL
                                }
                            }
                            
                        }
                        
                    })
                    task.resume()
                }
            }
        //ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            
        })
    
    }

    func downloadTavern() {
        
        let encodedString = arcanaURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
        let encodedURL = URL(string: "\(baseURL)\(encodedString!)")

        
        do {
            let html = try String(contentsOf: encodedURL!, encoding: String.Encoding.utf8)
            if html.contains("入　手　方　法") {
                print("FOUND 入　手　方　法")
                let trim = html.substring(with: Range<String.Index>(html.indexOf("入　手　方　法")!..<html.indexOf("専　用　武　器")!))
                print(trim)
                if let doc = Kanna.HTML(html: trim, encoding: String.Encoding.utf8) {
                    for tavern in doc.xpath(".//a[@href]") {
                        print(tavern.text)
                    }

                }
            }
            

            
        } catch {
            print("PARSING ERROR")
        }

    }
    
    func downloadWeaponAndPicture(_ string: String, url: URL) {
        
            do {
                let html = try String(contentsOf: url, encoding: String.Encoding.utf8)
                
                if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                    
                    var textWithWeapon = ""
                    // Search for nodes by XPath
                    findingTable : for (index, link) in doc.xpath("//table[@id='']").enumerate() {
                        
                        let tables = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                        
                        guard let linkText = link.text else {
                            return
                        }
                        if index == 0 {
                            for a in tables!.xpath("//a | //link") {
                                if let a = a["href"] {
                                    dict.updateValue("\(a)", forKey: "imageURL")
                                }
                                else {
                                    print("IMAGE URL NOT FOUND")
                                }
                            }
                        }
                        if linkText.containsString("斬") || linkText.containsString("打") || linkText.containsString("突") || linkText.containsString("弓") || linkText.containsString("魔") || linkText.containsString("聖") || linkText.containsString("拳") || linkText.containsString("銃") || linkText.containsString("狙") {
                            
                            
                            // Nested Loop. Should return right at first iteration.
                            for (weaponIndex, a) in tables!.xpath(".//a['title']").enumerate() {
                                
                                if weaponIndex == 0 {
                                    if let text = a.text {
                                        textWithWeapon.appendContentsOf(text)
                                        break findingTable
                                    }
                                }
                            }
                            
                        }
                        
                    }
                    
                    if textWithWeapon == "" {
                        print("WEAPON IS BLANK")
                    }
                    if string == "new" {
                        dict.updateValue("\(getWeapon(textWithWeapon)) / \(textWithWeapon)", forKey: "weapon")

                    }
                }
                
            } catch {
                print("PARSING ERROR")
            }


        
    }

    // MARK: Given old or new page, parses the page.
    func downloadAttributes(_ string: String, html: String) {
        

        if string == "new" {
                
                print("IDENTIFIED NEW PAGE")
            
                // Kanna, search through html
                
                if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                    // TODO: check for # of skills
                    var numberOfSkills = 0
                    
                    if !html.contains("SKILL 2") {    // Only has 1 skill
                        numberOfSkills = 1
                    }
                    else if !html.contains("SKILL 3") {   // Only has 2 skills
                        numberOfSkills = 2
                    }
                    else {  // Only has 3 skills
                        numberOfSkills = 3
                    }
                    
                    var numberOfAbilities = 0
                    
                    
                    // Fetched required attributes
                    for (index, link) in doc.xpath("//tbody").enumerate() {
                        print(index, link.text!)
                        switch index {
                            
                            
                        case 0: // Arcana base info
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                
                                guard let attribute = a.text else {
                                    return
                                }
                                
                                switch attIndex {
                                case 0:
                                    // use this name to search through arcanaData.txt and find name+nickname
                                    
                                    if self.getAttributes(attribute, foundRarity: true) == false {
                                        //TODO: Update names.
                                        self.dict.updateValue(attribute, forKey: "nameJP")
                                        self.translate(attribute, key: "nameKR")
                                    }
                                    //self.downloadIcon(attribute)
                                case 1:
                                    let rarity = self.getRarity(attribute)
                                    // check if rarity is 3 or lower
                                    //print(attribute)
                                    if rarity == "2" && rarity == "3" {
                                        numberOfAbilities = 1
                                    }
                                    else if rarity == "1" {
                                        numberOfAbilities = 0
                                    }
                                    
                                    self.dict.updateValue(rarity, forKey: "rarity")
                                case 3:
                                    
                                    // Check if this arcana existed in arcanaData
                                    //if self.dict["group"] == nil {
                                    
                                    self.dict.updateValue(self.getClass(attribute), forKey: "group")
                                //}
                                case 4:
                                    // Check if this arcana existed in arcanaData
                                    //  if self.dict["affiliation"] == nil {
                                    
                                    self.dict.updateValue(self.getAffiliation(attribute), forKey: "affiliation")
                                // }
                                case 7:
                                    self.dict.updateValue(attribute, forKey: "cost")
                                default:
                                    break
                                }
                            }
                            
                            
                        case 2: // Kizuna
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                guard let attribute = a.text else {
                                    return
                                }
                                
                                switch attIndex {
                                    
                                case 1:
                                    
                                    self.translate(attribute, key: "kizunaName")
                                case 2:
                                    self.dict.updateValue(attribute, forKey: "kizunaCost")
                                case 3:
                                    self.translate(attribute, key: "kizunaAbility")
                                default:
                                    break
                                }
                            }
                            
                        case 3: // Skill 1
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                guard let attribute = a.text else {
                                    return
                                }
                                switch attIndex {
                                    
                                case 0:
                                    
                                    self.translate(attribute, key: "skillName1")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "skillMana1")
                                case 2:
                                    //print("SKILL DESC1 is \(attribute)")
                                    //dispatch_group_enter(self.group)
                                    
                                    self.translate(attribute, key: "skillDesc1")
                                default:
                                    break
                                }
                            }
                            
                            // Skip cases 4,5 if only one skill
                            
                        case 4: // Skill 2
                            if numberOfSkills == 1 {
                                // Just get ability 1
                                self.dict.updateValue("1", forKey: "skillCount")
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName1")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc1")
                                    default:
                                        break
                                    }
                                }
                                
                                break
                            }
                            
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                guard let attribute = a.text else {
                                    return
                                }
                                switch attIndex {
                                    
                                case 0:
                                    
                                    self.translate(attribute, key: "skillName2")
                                case 1:
                                    self.dict.updateValue(attribute, forKey: "skillMana2")
                                case 2:
                                    
                                    self.translate(attribute, key: "skillDesc2")
                                default:
                                    break
                                }
                            }
                            
                        case 5:
                            print("CASE 5 HERE")
                            switch numberOfSkills {
                                
                            case 1:
                                // get 인연이야기.
                                if numberOfAbilities == 1 {
                                    break
                                }
                                // Just get ability 2
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                //print("ABILITY 2 TEXT")
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName2")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc2")
                                    default:
                                        break
                                    }
                                }
                                break
                                
                            case 2:
                                // Just get ability 1
                                self.dict.updateValue("2", forKey: "skillCount")
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName1")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc1")
                                    default:
                                        break
                                    }
                                }
                                break
                                
                            default:
                                
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    
                                    guard let attribute = a.text else {
                                        print("ATTRIBUTE IS UNWRAPPED")
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "skillName3")
                                    case 1:
                                        self.dict.updateValue(attribute, forKey: "skillMana3")
                                    case 2:
                                        
                                        self.translate(attribute, key: "skillDesc3")
                                    default:
                                        break
                                    }
                                }
                            }
                            
                        case 6:
                            print("case 6")
                            if numberOfSkills == 1 {
                                break
                            }
                            else if numberOfSkills == 2 { // numberofskills 2, get ability 2
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName2")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc2")
                                    default:
                                        break
                                    }
                                }
                            }
                            else {  // numberofskills = 3
                                self.dict.updateValue("3", forKey: "skillCount")
                                
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    switch attIndex {
                                        
                                    case 0:
                                        
                                        self.translate(attribute, key: "abilityName1")
                                    case 1:
                                        
                                        self.translate(attribute, key: "abilityDesc1")
                                    default:
                                        break
                                    }
                                }
                            }
                            
                            break
                            
                        case 7:
                            guard numberOfSkills == 3 else {
                                //print("ONLY 1 OR 2 SKILL, DON'T COME THIS FAR")
                                break
                            }
                            let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                            
                            for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                guard let attribute = a.text else {
                                    return
                                }
                                
                                switch attIndex {
                                    
                                case 0:
                                    
                                    self.translate(attribute, key: "abilityName2")
                                case 1:
                                    
                                    self.translate(attribute, key: "abilityDesc2")
                                default:
                                    break
                                }
                            }
                            
                        case 9:
                            if numberOfSkills == 1 {
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    print(attIndex, a.text)
                                    switch attIndex {
                                        
                                    case 0:
                                        self.translate(self.getTavern(attribute), key: "tavern")
                                        // case 1. added date.
                                        
                                    default:
                                        break
                                    }
                                }
                            }
                        case 10:
                            if numberOfSkills == 2 {
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    print(attIndex, a.text)
                                    switch attIndex {
                                        
                                    case 0:
                                        self.translate(self.getTavern(attribute), key: "tavern")
                                        // case 1. added date.
                                        
                                    default:
                                        break
                                    }
                                }
                            }
                        case 11:
                            if numberOfSkills == 3 {
                                let table = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                                
                                for (attIndex, a) in table!.xpath(".//td").enumerate() {
                                    guard let attribute = a.text else {
                                        return
                                    }
                                    print(attIndex, a.text)
                                    switch attIndex {
                                        
                                    case 0:
                                        self.translate(self.getTavern(attribute), key: "tavern")
                                        // case 1. added date.
                                        
                                    default:
                                        break
                                    }
                                }
                            }
                        default:
                            break
                        }
                        
                    }
                    // After fetching, print array
                    //                    dispatch_async(dispatch_get_main_queue()) {
                    //                        //self.uploadArcana()
                    //
                    //                    }
                    
                    
                    
                }
            }
        
        
        else {
            print("IDENTIFIED OLD PAGE")
            
            
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                
                // Search for nodes by XPath
                for (index, link) in doc.xpath("//table[@id='']").enumerate() {
                    
                    let tables = Kanna.HTML(html: link.innerHTML!, encoding: NSUTF8StringEncoding)
                    
                    guard let linkText = link.text else {
                        return
                    }
                    if index == 0 {
                        for a in tables!.xpath("//a | //link") {
                            if let a = a["href"] {
                                print(a)
                                self.dict.updateValue("\(a)", forKey: "imageURL")
                            }
                            else {
                                print("IMAGE URL NOT FOUND")
                            }
                        }
                    }
                }
            }
            
            // Already has skill count 1
            self.dict.updateValue("1", forKey: "skillCount")
            guard let h = html.indexOf("ス　キ　ル") else {
                print("POSSIBLY BLANK PAGE FOR  \(html)")
                return
            }
            var trim = NSString(string: html.substring(with: Range<String.Index>(html.indexOf("<hr />")!..<h)))
            
            var lines = trim.components(separatedBy: "<br>")
            // CHECK IF OLD, OR OLDEST
            
            // oldest
            if !lines[0].contains("名　前") {
                // change trim and lines
                trim = NSString(string: html.substring(with: Range<String.Index>(html.indexOf("</tbody></table>")!..<h)))
                lines = trim.components(separatedBy: "<br>")
            }
        
            
            var usefulAttributes = [String]()
            var foundRarity = true
            for i in lines {
                if i.contains("名　前") || i.contains("レアリティ") || i.contains("コ　ス　ト") || i.contains("コスト") || i.contains("職　業") || i.contains("職業") || i.contains("武器タイプ") || i.contains("ＳＫＩＬＬ") || i.contains("ＡＢＩＬＩＴＹ") || i.contains("絆アビリティ") || i.contains("入　手　方　法") {
                    usefulAttributes.append(i)
                    
                }
                
            }
            
            
            // no rarity found??
            if !usefulAttributes[1].contains("レアリティ") {
                usefulAttributes.insert("0", at: 1)
                foundRarity = false
            }
            
            var foundKizuna = true
            // arcana only has 1 ability, so index 7 should be kizuna. check if kizuna found.
            if !usefulAttributes[7].contains("絆アビリティ") && !usefulAttributes[7].contains("ＡＢＩＬＩＴＹ") {
                usefulAttributes.insert("정보 없음", at: 7)
                foundKizuna = false
            }
            
            var numberOfAbilities = 2
            
            for (index, i) in usefulAttributes.enumerated() {
                
                let regexSpan = try! NSRegularExpression(pattern: "<span.*</span></span>　", options: [.caseInsensitive])
                let regex = try! NSRegularExpression(pattern: "<.*?>", options: [.caseInsensitive])
                let rangeSpan = NSMakeRange(0, i.characters.count)
                
                let spanLessString :String = regexSpan.stringByReplacingMatches(in: i, options: [], range:rangeSpan, withTemplate: "")
                let range = NSMakeRange(0, spanLessString.characters.count)
                
                let htmlLessString :String = regex.stringByReplacingMatches(in: spanLessString, options: [], range:range, withTemplate: "")
                
                let attribute = htmlLessString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                //print(index, attribute)
                
                print(index, attribute)
                switch index {
                    
                case 0:
                    if self.getAttributes(attribute, foundRarity: foundRarity) == false {
                        //TODO: Update names.
                        self.dict.updateValue(attribute, forKey: "nameJP")
                        self.translate(attribute, key: "nameKR")
                    }
                    
                case 1:
                    
                    // check if rarity is 3 or lower
                    if foundRarity == true {
                        let rarity = self.getRarity(attribute)
                        
                        if rarity == "2" || rarity == "3" {
                            numberOfAbilities = 1
                        } else if rarity == "1" {
                            numberOfAbilities = 0
                        }
                        self.dict.updateValue(rarity, forKey: "rarity")
                    }
                    
                    
                case 2:
                    self.dict.updateValue(attribute, forKey: "cost")
                    
                case 3:
                    // Get group inside ()
                    var group = String()
                    if let _ = attribute.indexOf("(") {
                        group = NSString(string: attribute.substring(with: Range<String.Index>(<#T##String.CharacterView corresponding to your index##String.CharacterView#>.index(attribute.indexOf("(")!, offsetBy: 1)..<attribute.indexOf(")")!))) as String
                    }
                    else if let _ = attribute.indexOf("（") {
                        group = NSString(string: attribute.substring(with: Range<String.Index>(<#T##String.CharacterView corresponding to your index##String.CharacterView#>.index(attribute.indexOf("（")!, offsetBy: 1)..<attribute.indexOf("）")!))) as String
                    }
                    else {
                        group = attribute
                    }
                    self.dict.updateValue(self.getClass(group), forKey: "group")

                
                case 4:
                    self.dict.updateValue(self.getWeapon(attribute), forKey: "weapon")
                    
                case 5:
                    
                    let skillName1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.indexOf("(")!))))
                    self.translate(skillName1, key: "skillName1")
                    if let _ = attribute.indexOf(")*") {
                        let skillMana1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf(")*")!, offsetBy: 2)..<attribute.index(attribute.indexOf(")*")!, offsetBy: 3)))))
                        self.translate(skillMana1, key: "skillMana1")
                        let skillDesc1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf(")*")!, offsetBy: 3)..<attribute.endIndex))))
                        self.translate(skillDesc1, key: "skillDesc1")
                    }
                    
                    else {
                        let skillMana1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("(")!, offsetBy: 1)..<attribute.index(attribute.indexOf("(")!, offsetBy: 2)))))
                        self.translate(skillMana1, key: "skillMana1")
                        let skillDesc1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("(")!, offsetBy: 2)..<attribute.endIndex))))
                        self.translate(skillDesc1, key: "skillDesc1")
                    }
                    
                    
                case 6:
                    if numberOfAbilities == 0 {
                        if foundKizuna {
                            let kizunaName = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.indexOf("(")!))))
                            self.translate(kizunaName, key: "kizunaName")
                            let kizunaCost = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("+")!, offsetBy: 1)..<attribute.index(attribute.indexOf("+")!, offsetBy: 2)))))
                            self.translate(kizunaCost, key: "kizunaCost")
                            let kizunaAbility = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf(")　")!, offsetBy: 2)..<attribute.endIndex))))
                            self.translate(kizunaAbility, key: "kizunaAbility")
                        }
                        else {
                            self.dict.updateValue("정보 없음", forKey: "kizunaName")
                            self.dict.updateValue("-", forKey: "kizunaCost")
                            self.dict.updateValue("정보 없음", forKey: "kizunaAbility")
                        }

                    }
                    else if let _ = attribute.indexOf("　") {
                        let abilityName1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.index(before: attribute.indexOf("　")!)))))
                        self.translate(abilityName1, key: "abilityName1")
                        let abilityDesc1 = String(NSString(string: attribute.substring(with: Range<String.Index>(<#T##String.CharacterView corresponding to your index##String.CharacterView#>.index(attribute.indexOf("　")!, offsetBy: 1)..<attribute.endIndex))))
                        self.translate(abilityDesc1, key: "abilityDesc1")
                    }
                    else {
                        let abilityName1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.index(before: attribute.indexOf("：")!)))))
                        self.translate(abilityName1, key: "abilityName1")
                        let abilityDesc1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("：")!, offsetBy: 1)..<attribute.endIndex))))
                        self.translate(abilityDesc1, key: "abilityDesc1")
                    }
                    
                case 7:
                    print("INDEX 7 HAS \(attribute)")
                    if numberOfAbilities == 0 {
                        self.dict.updateValue(self.getTavern(attribute), forKey: "tavern")
                    }
                    else if numberOfAbilities == 1 {
                        if foundKizuna {
                            let kizunaName = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.indexOf("(")!))))
                            self.translate(kizunaName, key: "kizunaName")
                            let kizunaCost = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("+")!, offsetBy: 1)..<attribute.index(attribute.indexOf("+")!, offsetBy: 2)))))
                            self.translate(kizunaCost, key: "kizunaCost")
                            let kizunaAbility = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf(")　")!, offsetBy: 2)..<attribute.endIndex))))
                            self.translate(kizunaAbility, key: "kizunaAbility")
                        }
                        else {
                            self.dict.updateValue("정보 없음", forKey: "kizunaName")
                            self.dict.updateValue("-", forKey: "kizunaCost")
                            self.dict.updateValue("정보 없음", forKey: "kizunaAbility")
                        }
                        
                    }
                    else {
                        if let _ = attribute.indexOf("　") {
                            let abilityName2 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.index(before: attribute.indexOf("　")!)))))
                            self.translate(abilityName2, key: "abilityName2")
                            let abilityDesc2 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("　")!, offsetBy: 1)..<attribute.endIndex))))
                            self.translate(abilityDesc2, key: "abilityDesc2")
                        }
                        else if let _ = attribute.indexOf("：") {
                            
                            let abilityName2 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.index(before: attribute.indexOf("：")!)))))
                            self.translate(abilityName2, key: "abilityName2")
                            let abilityDesc2 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("：")!, offsetBy: 1)..<attribute.endIndex))))
                            self.translate(abilityDesc2, key: "abilityDesc2")
                        }
                        else {
                            
                        }
                    }

                case 8:
                    if numberOfAbilities == 0 {
                        break
                    } else if numberOfAbilities == 1 {
                        self.dict.updateValue(self.getTavern(attribute), forKey: "tavern")
                    }
                    else {
                        let kizunaName = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.indexOf("(")!))))
                        self.translate(kizunaName, key: "kizunaName")
                        let kizunaCost = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("+")!, offsetBy: 1)..<attribute.index(attribute.indexOf("+")!, offsetBy: 2)))))
                        self.translate(kizunaCost, key: "kizunaCost")
                        let kizunaAbility = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf(")　")!, offsetBy: 2)..<attribute.endIndex))))
                        self.translate(kizunaAbility, key: "kizunaAbility")
                    }
                    
                case 9:
                    if numberOfAbilities == 0 || numberOfAbilities == 1{
                        break
                    }
                    else {
                        self.dict.updateValue(self.getTavern(attribute), forKey: "tavern")
                    }
                default:
                    break
                }
            }
        }
        // WAIT FOR ALL TRANSLATIONS, THEN UPLOAD
        group.notify(queue: DispatchQueue.main, execute: { // Calls the given block when all blocks are finished in the group.
            // All blocks finished, do whatever you like.
            print("TRANSLATED ARCANA")
            self.download.leave()
            
            for (key, value) in self.dict {
                print(key, value)
            }
            self.uploadArcana()
        })
        
        
        
    }
    
    func downloadArcana(_ index: Int) {
        
        download.enter()
        // TODO: Check if the page has #ui_wikidb. If it does, it is the new page, if it doesn't, it is the old page.
 
            let encodedString = "言葉無き吟遊詩人ロクサーナ".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            let encodedURL = URL(string: "\(self.baseURL)\(encodedString!)")
        
            // first check if this exists in firebase
        let ref = FIREBASE_REF.child("arcana")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var exists = false
            
            for arcana in snapshot.children {

                if self.urls[index].contains((arcana as AnyObject).value!["nameJP"] as! String) {
                    exists = true
                }
                
            }
            
            if exists == true {
                print("\(self.urls[index]) ALREADY EXISTS")
                self.download.leave()
                self.downloadArcana(index + 1)
            }
            
            else {
                // proceed to download
                
                print("PARSING...")
                print(encodedURL!)
                
                
                do {
                    let html = try String(contentsOf: encodedURL!, encoding: String.Encoding.utf8)
                    
                    
                    // TODO: THERE ARE ACTUALLY 3 TYPES OF PAGES.
                    // IF IT IS THE OLDEST, IT WONT HAVE <HR>. SO INSTEAD OF PARSING LIKE AN OLD PAGE, SEARCH ARCANADATA FOR BASIC ATTRIBUTES, THEN ONLY GET SKILL/ABILITIES FROM HTML.
                    
                    
                    if html.contains("#ui_wikidb") {
                        self.downloadAttributes("new", html: html)
                        self.downloadWeaponAndPicture("new", url: encodedURL!)
                        
                    }
                        
                    else {
                        self.downloadAttributes("old", html: html)
                        
                        self.downloadWeaponAndPicture("old", url: encodedURL!)
                        
                    }
                    
                    
                }
                    
                catch {
                    print(error)
                }
                
                
                self.download.notify(queue: DispatchQueue.main, execute: {
                    print("Finished translating.")
                
                    self.loop.notify(queue: DispatchQueue.main, execute: {
                        print("Finished uploading.")
                        self.downloadArcana(index + 1)
                        
                    })
                })
            }
        })
        
        
    }
    
    func translate(_ value: String, key: String) {
        
        
        
        let encodedString = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        
        if let encodedString = encodedString {
            group.enter()
            
            let url = URL(string: "https://www.googleapis.com/language/translate/v2?key=\(API_KEY)&q=\(encodedString)&source=ja&target=ko")
            
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    if let translatedText = json["data"]["translations"][0]["translatedText"].string {
                        

                        // get rid of &quot; and &lt &gt;
                        var t = translatedText.stringByReplacingOccurrencesOfString("&quot;", withString: " ")
                        t = t.stringByReplacingOccurrencesOfString("&lt;", withString: "")
                        t = t.stringByReplacingOccurrencesOfString("&gt;", withString: "")
                        // some have quotes at start, so remove whitespace
                        t = t.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
                        // remove double spaces
                        t = t.stringByReplacingOccurrencesOfString("  ", withString: " ")
                        // remove space in front of %
                        t = t.stringByReplacingOccurrencesOfString(" %", withString: "%")
                        print("TRANSLATED TEXT IS \(t)")
                        self.dict.updateValue(t, forKey: key)
                        //self.dict.updateValue(String(htmlEncodedString: final), forKey: key)
                        self.group.leave()
                    }
                    
                }
            })
            task.resume()
        }
        

    }
    
    func uploadArcana() {
        
        loop.enter()
        let ref = FIREBASE_REF.child("arcana")

        
        print("STARTING UPLOAD PROCESS")
        
        
        // Check if arcana already exists
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var exists = false
            
            for i in snapshot.children {
                let s = (i as AnyObject).value!["nameJP"] as! String
                let d = self.dict["nameJP"]!
                if s == d {
                    exists = true
                }
                
            }
            
            if exists == true {
                print("\(self.dict["nameKR"]) ALREADY EXISTS")
                self.loop.leave()
            }
            
            else {
            
                let id = ref.childByAutoId().key
                // translate, put korean in dict values.
                self.dict["uid"] = id
                // TODO: check skillcount. if 1, just do normal. if 2 or 3, just upload the single skill2 or skill3 key-values.
                
                
                // Base Case: only 1 skill, 1 ability. Does not have nickname.
                // TODO: Change base case to 1 skill 0 ability...
                guard let nKR = self.dict["nameKR"], let nJP = self.dict["nameJP"], let r = self.dict["rarity"], let g = self.dict["group"], let t = self.dict["tavern"], let a = self.dict["affiliation"], let c = self.dict["cost"], let w = self.dict["weapon"], let kN = self.dict["kizunaName"], let kC = self.dict["kizunaCost"], let kA = self.dict["kizunaAbility"], let sC = self.dict["skillCount"], let sN1 = self.dict["skillName1"], let sM1 = self.dict["skillMana1"], let sD1 = self.dict["skillDesc1"], let aN1 = self.dict["abilityName1"], let aD1 = self.dict["abilityDesc1"] else {
                    
                    print("ARCANA DICIONARY VALUE IS NIL")
                    return
                }
                
                
                guard let imageURL = self.dict["imageURL"] else {
                    print("COULD NOT GET IMAGEURL FROM DICTIONARY")
                    return
                }
                
                
                
                
                let arcanaOneSkill = ["uid" : "\(id)", "nameKR" : "\(nKR)", "nameJP" : "\(nJP)", "rarity" : "\(r)", "class" : "\(g)", "tavern" : "\(t)", "affiliation" : "\(a)", "cost" : "\(c)", "weapon" : "\(w)", "kizunaName" : "\(kN)", "kizunaCost" : "\(kC)", "kizunaAbility" : "\(kA)", "skillCount" : "\(sC)", "skillName1" : "\(sN1)", "skillMana1" : "\(sM1)", "skillDesc1" : "\(sD1)", "abilityName1" : "\(aN1)", "abilityDesc1" : "\(aD1)", "numberOfViews" : 0, "imageURL" : "\(imageURL)"] as [String : Any]
                
                let arcanaRef = ["\(id)" : arcanaOneSkill]
                
                // check for ability types
                self.findAbilities()
                
                ref.updateChildValues(arcanaRef, withCompletionBlock: { completion in
                    print("UPLOADED ARCANA")
                    // Check if arcana was in file. If yes, get nicknames, iconURL
                    
                    if let nnKR = self.dict["nickKR"], let nnJP = self.dict["nickJP"], let iconURL = self.dict["iconURL"] {
                        let nickNameRef = FIREBASE_REF.child("arcana/\(id)")
                        let nickNameAndIconRef = ["nickNameKR" : "\(nnKR)", "nickNameJP" : "\(nnJP)", "iconURL" : "\(iconURL)"]
                        //dispatch_group_enter(self.loop)
                        nickNameRef.updateChildValues(nickNameAndIconRef, withCompletionBlock: { completion in
                            print("uploaded nickname and iconurl")
                            self.loop.leave()
                        })
                    }
                        
                    else {
                        print("COULD NOT FIND ARCANA IN FILE. NO NICKNAME AND ICONURL")
                    }
                    self.loop.notify(queue: DispatchQueue.main, execute: { // Calls the given block when all blocks are finished in the group.
                        print("notified")
        //                dispatch_group_wait(self.group, 3000)
                        // Check if arcana has 2 abilities
                        if r.contains("5") || r.contains("4") {
                            print("RARITY IS 4 or 5")
                            guard let aN2 = self.dict["abilityName2"], let aD2 = self.dict["abilityDesc2"] else {
                                return
                            }
                            
                            let newArcanaRef = FIREBASE_REF.child("arcana/\(id)")
                            let abilityRef = ["abilityName2" : "\(aN2)", "abilityDesc2" : "\(aD2)"]
                            self.loop.enter()
                            // Upload Ability 2
                            newArcanaRef.updateChildValues(abilityRef, withCompletionBlock: { completion in
                                
                                // Check if arcana has at least 2 skills
                                if let sN2 = self.dict["skillName2"], let sM2 = self.dict["skillMana2"], let sD2 = self.dict["skillDesc2"] {
                                    
                                    switch (sC) {
                                    case "2":
                                        
                                        let skill2 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)"]
                                        newArcanaRef.updateChildValues(skill2, withCompletionBlock: { completion in
                                            self.loop.leave()

                                        })
                                        
                                    case "3":
                                        
                                        if let sN2 = self.dict["skillName2"], let sM2 = self.dict["skillMana2"], let sD2 = self.dict["skillDesc2"], let sN3 = self.dict["skillName3"], let sM3 = self.dict["skillMana3"], let sD3 = self.dict["skillDesc3"] {
                                            let skill3 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)", "skillName3" : "\(sN3)", "skillMana3" : "\(sM3)", "skillDesc3" : "\(sD3)"]
                                            newArcanaRef.updateChildValues(skill3, withCompletionBlock: { completion in
                                                self.loop.leave()

                                            })
                                        }
                                        
                                    default:
                                        

                                        break
                                        
                                    }
                                    
                                    
                                }
                                self.loop.leave()
                                
                            })
                            
                        }
                        // rarity 1,2,3. only has 1 ability
                        else {
                        }
                        
                        
                        })
                    })
            }
        })
        
    }
    
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
                if aD1.contains("마나 슬롯") && aD1.contains("속도") {
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
                if aD2.contains("마나 슬롯") && aD2.contains("속도") {
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
            if let k = self.dict["kizunaAbility"] {
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
                if (k.contains("슬로우") || k.contains("스러운")) && k.contains("않는다") {
                    let kizunaRef = FIREBASE_REF.child("manaChanceABility/\(id)")
                    kizunaRef.setValue(true)
                }
            }
        }
        
    }
    
    func getRarity(_ string: String) -> String {
        
        switch string {
            
        case "★★★★★SSR", "SSR":
            return "5"
        case "★★★★SR", "SR":
            return "4"
        case "★★★R", "R":
            return "3"
        case "★★HN", "HN":
            return "2"
        case "★N", "N":
            return "1"
        default:
            return "0"
        }
        
    }
    
    func getClass(_ string: String) -> String {
        switch string {
            
        case "戦士":
            return "전사"
        case "騎士":
            return "기사"
        case "弓使い":
            return "궁수"
        case "魔法使い":
            return "법사"
        case "僧侶":
            return "승려"
        default:
            return ""
        }
        
    }
    
    func getTavern(_ string: String) -> String {
        
        let taverns = ["副都", "聖都", "賢者の塔", "迷宮山脈", "砂漠の湖都", "精霊島", "炎の九領", "海風の港", "夜明けの大海", "ケ者の大陸", "罪の大陸", "薄命の大陸", "鉄煙の大陸", "書架", "レムレス島", "魔神", "ガチャ", "グ交換"]
        var tav = ""
        
        for (index, t) in taverns.enumerated() {
            if string.contains(t) {
                tav = taverns[index]
                break
            }
        }
        
        switch tav {
            
        case "副都":
            return "부도"
        case "聖都":
            return "성도"
        case "賢者の塔":
            return "현자의탑"
        case "迷宮山脈":
            return "미궁산맥"
        case "砂漠の湖都":
            return "호수도시"
        case "精霊島":
            return "정령섬"
        case "炎の九領":
            return "화염구령"
        case "海風の港":
            return "해풍의항구"
        case "夜明けの大海":
            return "새벽대해"
        case "ケ者の大陸":
            return "개들의대륙"
        case "罪の大陸":
            return "죄의대륙"
        case "薄命の大陸":
            return "박명의대륙"
        case "鉄煙の大陸":
            return "철연의대륙"
        case "年代記の大陸":
            return "연대기의대륙"
        case "レムレス島":
            return "레무레스섬"
        case "魔神":
            return "마신"
        case "義勇軍":
            return "의용군"
        case "ガチャ":
            return "링가챠"
        case "グ交換":
            return "링교환"
        default:
            return ""
        }
        
    }

    func getAffiliation(_ string: String) -> String {
        
        switch string {
        case "副都":
            return "부도"
        case "聖都":
            return "성도"
        case "賢者の塔":
            return "현자의탑"
        case "迷宮山脈":
            return "미궁산맥"
        case "砂漠の湖都":
            return "호수도시"
        case "精霊島":
            return "정령섬"
        case "九領":
            return "화염구령"
        case "大海":
            return "대해"
        case "ケ者の大陸":
            return "개들의대륙"
        case "罪の大陸":
            return "죄의대륙"
        case "薄命の大陸":
            return "박명의대륙"
        case "鉄煙の大陸":
            return "철연의대륙"
        case "年代記の大陸":
            return "연대기의대륙"
        case "レムレス島":
            return "레무레스섬"
        case "魔神":
            return "마신"
        case "旅人":
            return "여행자"
        case "義勇軍":
            return "의용군"
            
        default:
            return ""
        }
        
    }
    
    func getWeapon(_ string: String) -> String {
        
        let s = string[string.startIndex]
        switch s {
            
        case "斬":
            return "검"
        case "打":
            return "봉"
        case "突":
            return "창"
        case "弓":
            return "궁"
        case "魔":
            return "마"
        case "聖":
            return "성"
        case "拳":
            return "권"
        case "銃":
            return "총"
        case "狙":
            return "저"

        default:
            return "0"
        }
        
    }


    
    func getAttributes(_ string: String, foundRarity: Bool) -> Bool {
        print("SEARCHING FOR \(string)")
        
        let path = Bundle.main.path(forResource: ".//arcanaData", ofType: "txt")
        let file = try? NSString(contentsOfFile: path! as String, encoding: String.Encoding.utf8.rawValue)
        let data: Data? = try? Data(contentsOf: URL(fileURLWithPath: path!))
        //print(data)
        do {
            let jsonObject : AnyObject! =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            let json = JSON(jsonObject)
            let a = string.substring(to: string.characters.index(string.startIndex, offsetBy: 3))
            var contains = false
            
            for (_, subJson) : (String, JSON) in json["array"] {
                
                // Checking for nickname because of ver 2.
                if string.containsString(subJson["nickname"].stringValue) {
                    // check if we need all attributes(Oldest) or some
//                    if type == "oldest" {
//                        let rarity = subJson["rank"].stringValue
//                        let group = subJson["job"].stringValue
//                        let weapon = subJson["wepon"].stringValue
//                        let cost = subJson["cost"].stringValue
//                        let affiliation = subJson["syozoku"].stringValue
//                    }
                    if foundRarity == false {
                        let rarity = subJson["rank"].stringValue
                        self.dict.updateValue(self.getRarity(rarity), forKey: "rarity")
                        
                    }
                    
                    let nameJP = subJson["name"].stringValue
                    var nickJPQuotes = subJson["nickname"].stringValue
                    // get rid of quotation in names.
                    nickJPQuotes = nickJPQuotes.stringByReplacingOccurrencesOfString("“", withString: " ")
                    nickJPQuotes = nickJPQuotes.stringByReplacingOccurrencesOfString("”", withString: " ")
                    // some have quotes at start, so remove whitespace
                    let nickJP = nickJPQuotes.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
                    
                    let affiliation = subJson["syozoku"].stringValue
                    self.translate(nameJP, key: "nameKR")
                    self.translate(nickJP, key: "nickKR")
                    let arcanaID = subJson["No"].stringValue
                    print("FOUND ID # \(arcanaID) NAME \(nickJP)")
                    contains = true
                    self.dict.updateValue("\(nameJP)", forKey: "nameJP")
                    self.dict.updateValue("\(nickJP)", forKey: "nickJP")
                    self.dict.updateValue("http://chaincrers.webcrow.jp/icon/\(arcanaID).jpg", forKey: "iconURL")
                    self.dict.updateValue(self.getAffiliation(affiliation), forKey: "affiliation")
                    
                    
                    // Upload to firebase

                    break
                }
            }
            
            if contains == false {
                
                //TODO: get names from original html
                print("THIS ARCANA IS NOT IN THE TEXT FILE")
                return false
            }
            
            
            
        } catch {
            print(error)
        }
        return true
        
    }
    func retrieveURLS() {
        
        let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
        
        
        
        //print("SEARCHING FOR \(string)")
        
        let path = Bundle.main.path(forResource: ".//arcanaData", ofType: "txt")
        let file = try? NSString(contentsOfFile: path! as String, encoding: String.Encoding.utf8.rawValue)
        let data: Data? = try? Data(contentsOf: URL(fileURLWithPath: path!))
        
        do {
            let jsonObject : AnyObject! =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            let json = JSON(jsonObject)
            
            
            for (_, subJson) : (String, JSON) in json["array"] {
                let nameJP = subJson["name"].stringValue
                let nickJP = subJson["nickname"].stringValue
                //print("FOUND NAME \(nickJP)\(nameJP)")
                
                let arcanaURL = nickJP+nameJP
                self.urls.append(arcanaURL)
                
            }
        } catch {
            print(error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveURLS()
        //handleImage()
        downloadArcana(0)
//        for i in urls {
//            print(i)
//        }
        //let json = JSON(data: )
        //handleImage()
        //downloadTavern()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
//        for (index, u) in urls.enumerate() {
//            print(index, u)
//            
//        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func indexOf(_ string: String) -> String.Index? {
        return range(of: string, options: .literal, range: nil, locale: nil)?.lowerBound
    }
    
    init(htmlEncodedString: String) {
        do {
            let encodedData = htmlEncodedString.data(using: String.Encoding.utf8)!
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
                NSCharacterEncodingDocumentAttribute: String.Encoding.utf8 as AnyObject
            ]
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self.init(attributedString.string)
        } catch {
            fatalError("Unhandled error: \(error)")
        }
    }
    
    func deleteHTMLTag(_ tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(_ tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag)
        }
        return mutableString
    }
    
    
}

*/
