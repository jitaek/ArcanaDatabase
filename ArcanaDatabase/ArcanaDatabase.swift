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
    var dict = [String : String]()
    var arcanaID: Int?
    var arcanaArray = [Arcana]()
    
    
    @IBAction func updateImages(_ sender: Any) {
        
        downloadImages(uid: nameField.text!, imageURL: imageField.text!, iconURL: iconField.text!)
        
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
                        print(tavern.text!)
                    }

                }
            }
            

            
        } catch {
            print("PARSING ERROR")
        }

    }
    
    func downloadImage(_ string: String, url: URL) {
        
        
        do {
            let html = try String(contentsOf: url, encoding: String.Encoding.utf8)
            
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                
                // Search for nodes by XPath
                findingTable : for (index, link) in doc.xpath("//table[@id='']").enumerated() {
                    
                    let tables = Kanna.HTML(html: link.innerHTML!, encoding: String.Encoding.utf8)
                    
                    guard let _ = link.text else {
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
                    
                }

            }
            
        } catch {
            print("PARSING ERROR")
        }

    }
    
    

    // MARK: Given old or new page, parses the page.
    func downloadAttributes(_ string: String, html: String) {
        if string == "new" {
            var tables = [String : String]()
            var skillCount = "1"
            var foundChainStone = false
            let usefulAttributes = ["名　前", "武器タイプ", "絆ステタイプ", "SKILL", "SKILL 2", "SKILL 3", "ABILITY", "PARTYABILITY", "絆の物語", "入手方法", "運命の物語", "出会いの物語", "絆の物語",  "CHAIN STORY"]
            if html.contains("SKILL 3") {
                skillCount = "3"
            } else if html.contains("SKILL 2") {
                skillCount = "2"
            }
            self.dict.updateValue(skillCount, forKey: "skillCount")
            
            // NEW PAGE-2 stars have an ability, unlike old page.
            // Kanna, search through html
            var oneSkill = true
            if html.contains("SKILL 2") {
                oneSkill = false
            }
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                
                // Now getting tables.
                for table in doc.xpath("//table") {
                    // getting the innerhtml of tables. do i need to do this?
                    // for each table, iterate through the <th>
                    for th in table.xpath(".//th") {
//                        print("<<<<<<<\(th.text)")
                        for i in usefulAttributes {
                            let tableKey = th.text!
                            
                            // Some pages have SKILL VOICE.. check that it's not the voice..

                            if tableKey.contains(i) && !tableKey.contains("使用時") {
                                // check for "SKILL" and not 1,2,3
                                if (tableKey.contains("SKILL") || tableKey.contains("SKILL 1")) && !tableKey.contains("SKILL 2") && !tableKey.contains("SKILL 3") {
                                    tables.updateValue(table.innerHTML!, forKey: "SKILL")
                                }
                                else {
                                    if i == ("SKILL")  {
                                    }
                                    else if i == "ABILITY" && tables["ABILITY"] != nil && !tableKey.contains("PARTYABILITY"){
                                        tables.updateValue(table.innerHTML!, forKey: "ABILITY2")
                                        
                                    }
                                    else if i == "ABILITY" && tables["ABILITY"] != nil && tables["ABILITY2"] != nil{
                                        
                                        tables.updateValue(table.innerHTML!, forKey: "PARTYABILITY")
                                    }
                                    // check if 2nd ability
                                    
                                    else {
//                                        print("\(i) IS \(th.innerHTML!)")
                                        tables.updateValue(table.innerHTML!, forKey: i)
                                    }
                                    
                                    
                                }
                                
                                
                            }
                        }
                        if th.text!.contains("SKILL") && oneSkill == true && !th.innerHTML!.contains("使用時") {
                            tables.updateValue(table.innerHTML!, forKey: "SKILL")
                            
                        }
                        
                    }
                    
                }
            }
            for (key, value) in tables {
                
                let parse = Kanna.HTML(html: value, encoding: String.Encoding.utf8)

                switch key {
                    
                case "名　前":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
//                            if self.getAttributes(attribute, foundRarity: true) == false {
                                self.dict.updateValue(attribute, forKey: "nameJP")
                                self.translate(attribute, forKey: "nameKR")
//                            }
                            
                        case 1:
                            self.dict.updateValue(self.getRarity(attribute), forKey: "rarity")
                        case 3:
                            self.dict.updateValue(self.getClass(attribute), forKey: "group")
                        case 4:
                            self.dict.updateValue(self.getAffiliation(attribute), forKey: "affiliation")
                        case 7:
                            self.dict.updateValue(attribute, forKey: "cost")
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "絆ステタイプ":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        let attribute = link.text!
                        switch index {

                        case 1:
                            self.translate(attribute, forKey: "kizunaName")
                        case 2:
                            self.dict.updateValue(attribute, forKey: "kizunaCost")
                        case 3:
                            self.translate(attribute, forKey: "kizunaDesc")
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "武器タイプ":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        if index == 0 {
                            self.dict.updateValue(getWeaponJPKR(string: attribute.trimmingCharacters(in: .whitespacesAndNewlines)), forKey: "weapon")
                        }
                        else {
                            break
                        }
                        
                        
                    }
                case "SKILL", "SKILL 1":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            self.translate(attribute, forKey: "skillName1")
                        case 1:
                            self.dict.updateValue(attribute, forKey: "skillMana1")
                        case 2:
                            self.translate(attribute, forKey: "skillDesc1")
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "SKILL 2":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            self.translate(attribute, forKey: "skillName2")
                        case 1:
                            self.dict.updateValue(attribute, forKey: "skillMana2")
                        case 2:
                            self.translate(attribute, forKey: "skillDesc2")
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "SKILL 3":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            self.translate(attribute, forKey: "skillName3")
                        case 1:
                            self.dict.updateValue(attribute, forKey: "skillMana3")
                        case 2:
                            self.translate(attribute, forKey: "skillDesc3")
                        default:
                            break
                            
                            
                        }
                        
                    }
                    
                case "ABILITY":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        switch index {
                        case 0:
                            self.translate(attribute, forKey: "abilityName1")
                        case 1:
                            self.translate(attribute, forKey: "abilityDesc1")
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "ABILITY2":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        
                        switch index {
                        case 0:
                            self.translate(attribute, forKey: "abilityName2")
                        case 1:
                            self.translate(attribute, forKey: "abilityDesc2")
                        default:
                            break
                            
                        }
                        
                    }
                    
                case "PARTYABILITY":
                    
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        if index == 1 {
                            let attribute = link.text!
                            if attribute != "" {
                                self.translate(attribute, forKey: "partyAbility")
                            }
                            
                            break
                        }

                        
                    }
                    
                case "入手方法":
                    for (index, link) in parse!.xpath("//td").enumerated() {
                        
                        let attribute = link.text!
                        switch index {
                        case 0:
                            self.dict.updateValue(self.getTavern(attribute), forKey: "tavern")
                        case 1:
                            self.dict.updateValue(attribute, forKey: "dateAdded")
                        default:
                            break
                            
                        }
                        
                    }
                    
                    
                case "運命の物語", "出会いの物語", "絆の物語":
                    
                    if foundChainStone == true {
                        break
                    }
                    for link in parse!.xpath("//td") {
                        
                        let attribute = link.text!
                        if attribute.contains("精霊石") {
                            foundChainStone = true
                            let trailingString = attribute.substring(from: attribute.indexOf("Lv:")!)
                            // possibly more than one chainStone quest
                            let chainStoneLevel = String(NSString(string: trailingString.substring(with: Range<String.Index>(trailingString.index(trailingString.indexOf("Lv:")!, offsetBy: 3)..<trailingString.index(trailingString.indexOf("/")!, offsetBy: 0)))))
                            if let cS = self.dict["chainStone"] {
                                self.dict.updateValue("\(cS), 레벨 \(chainStoneLevel)", forKey: "chainStone")
                            }
                            else {
                                self.dict.updateValue("레벨 \(chainStoneLevel)", forKey: "chainStone")
                            }
                            
                            
                        }
                        
                        
                    }
                    
                case "CHAIN STORY":
                    for link in parse!.xpath("//td") {
                        let attribute = link.text!
                        if attribute.contains("章") && attribute.contains("】") {
                            self.translate(attribute, forKey: "chainStory")
                            break
                        }
                        
                    }
                    
                
                default:
                    break
                }
                
            }
        }
        
        
        else {
            print("IDENTIFIED OLD PAGE")
            
            
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                
                // Search for nodes by XPath
                for (index, link) in doc.xpath("//table[@id='']").enumerated() {
                    
                    let tables = Kanna.HTML(html: link.innerHTML!, encoding: String.Encoding.utf8)
                    
                    guard let _ = link.text else {
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
        
            
//            var usefulAttributes = [String]()
            let usefulKeys = ["名　前", "レアリティ", "コ　ス　ト", "コスト", "職　業", "職業", "武器タイプ", "ＳＫＩＬＬ", "ＡＢＩＬＩＴＹ", "絆アビリティ", "出会いの物語", "運命の物語", "絆の物語", "チェインストーリー", "入　手　方　法" ]
            var usefulAttributes = [String : String]()
            usefulAttributes.removeAll()
            var foundRarity = true
            for i in lines {
                for j in usefulKeys {
                    if i.contains(j) {
                        if j == "職　業" || j == "職業" {
                            if !i.contains("ＡＢＩＬＩＴＹ") {
                                usefulAttributes.updateValue(i, forKey: j)
                            }
                        } else if j == "コ　ス　ト" || j == "コスト" {
                            
                        // 'cost' appears in kizuna, so make sure it doesn't overlap
                            if !i.contains("絆アビリティ") {
                                usefulAttributes.updateValue(i, forKey: j)
                            }
                        }
                        else if j == "チェインストーリー" {
                            // chain story appears in chainstory festival..
                            if !i.contains("入　手　方　法")  {
                                usefulAttributes.updateValue(i, forKey: j)
                            }
                            
                        }
                        else {
                            // check if 2nd ability
                            if j == "ＡＢＩＬＩＴＹ" && usefulAttributes["ＡＢＩＬＩＴＹ"] != nil {
                                usefulAttributes.updateValue(i, forKey: "ＡＢＩＬＩＴＹ 2")
                            }
                            else {
                                usefulAttributes.updateValue(i, forKey: j)
                            }
                        }
                        

                    }
                }
            }
            
            
            // no rarity found??
            if usefulAttributes["レアリティ"] == nil {
                usefulAttributes.updateValue("0", forKey: "レアリティ")
                foundRarity = false
            }
            
            var foundKizuna = true
            // arcana only has 1 ability, so index 7 should be kizuna. check if kizuna found.
            if usefulAttributes["絆アビリティ"] == nil {
                usefulAttributes.updateValue("정보 없음", forKey: "絆アビリティ")
                foundKizuna = false
            }
            
            
            // index, i
            for (key, value) in usefulAttributes {
//                print(key, value)
                let regexSpan = try! NSRegularExpression(pattern: "<span.*</span></span>　", options: [.caseInsensitive])
                let regex = try! NSRegularExpression(pattern: "<.*?>", options: [.caseInsensitive])
                let rangeSpan = NSMakeRange(0, value.characters.count)
                
                let spanLessString :String = regexSpan.stringByReplacingMatches(in: value, options: [], range:rangeSpan, withTemplate: "")
                print(spanLessString)
                let range = NSMakeRange(0, spanLessString.characters.count)
                
                let htmlLessString :String = regex.stringByReplacingMatches(in: spanLessString, options: [], range:range, withTemplate: "")
                let removeStars = try! NSRegularExpression(pattern: "\\*.", options: [.caseInsensitive])
                let removeStarsRange = NSMakeRange(0, htmlLessString.characters.count)
                let removeStarsString = removeStars.stringByReplacingMatches(in: htmlLessString, options: [], range: removeStarsRange, withTemplate: "")
                
                var attribute = removeStarsString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                let badCharacters = ["（" : "(", "）": ")", "：" : "　"]
                
                for (key, value) in badCharacters {
                    attribute = attribute.replacingOccurrences(of: key, with: value)
                }
                
                
//                print(key, attribute)
                switch key {
                   
                case "名　前":
//                    if self.getAttributes(attribute, foundRarity: foundRarity) == false {
                        //TODO: Update names.
                        self.dict.updateValue(attribute, forKey: "nameJP")
                        self.translate(attribute, forKey: "nameKR")
//                    }
                    
                case "レアリティ":
                    
                    // check if rarity is 3 or lower
                    if foundRarity == true {
                        let rarity = self.getRarity(attribute)
                        
                        self.dict.updateValue(rarity, forKey: "rarity")
                    }
                    
                    
                case "コ　ス　ト", "コスト":
                    self.dict.updateValue(attribute, forKey: "cost")
                    
                case "職　業", "職業":   // TODO: class is sometimes found in ability mana description, make sure this doesn't happen
                    // Get group inside ()
                    print("GROUP IS \(attribute)")
                    var group = String()
                    if let _ = attribute.indexOf("(") {
                        group = NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("(")!, offsetBy: 1)..<attribute.indexOf(")")!))) as String
                    }
                    else if let _ = attribute.indexOf("（") {
                        group = NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("（")!, offsetBy: 1)..<attribute.indexOf("）")!))) as String
                    }
                    else {
                        group = attribute
                    }
                    self.dict.updateValue(self.getClass(group), forKey: "group")
                
                
                case "武器タイプ":
                    self.dict.updateValue(self.getWeapon(attribute), forKey: "weapon")
                    
                case "ＳＫＩＬＬ":

                    let skillName1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.indexOf("(")!))))
                    self.translate(skillName1, forKey: "skillName1")

                    let skillMana1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("(")!, offsetBy: 1)..<attribute.index(attribute.indexOf("(")!, offsetBy: 2)))))
                    self.dict.updateValue(_: skillMana1, forKey: "skillMana1")
                    let skillDesc1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf(")")!, offsetBy: 1)..<attribute.endIndex))))
                    self.translate(skillDesc1, forKey: "skillDesc1")

                    
                case "ＡＢＩＬＩＴＹ":
                    print("ABILITY IS")
                    if let _ = attribute.indexOf("　") {
                        let abilityName1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.indexOf("　")!))))
                        print(abilityName1)
                        self.translate(abilityName1, forKey: "abilityName1")
                        let abilityDesc1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("　")!, offsetBy: 1)..<attribute.endIndex))))
                        self.translate(abilityDesc1, forKey: "abilityDesc1")

                    }
    
                    else {
                        let abilityName1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.index(before: attribute.indexOf(" ")!)))))
                        self.translate(abilityName1, forKey: "abilityName1")
                        let abilityDesc1 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf(" ")!, offsetBy: 1)..<attribute.endIndex))))
                        self.translate(abilityDesc1, forKey: "abilityDesc1")
                    }
                    
                case "ＡＢＩＬＩＴＹ 2":
                    if let _ = attribute.indexOf("　") {
                        let abilityName2 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.index(before: attribute.indexOf("　")!)))))
                        self.translate(abilityName2, forKey: "abilityName2")
                        let abilityDesc2 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("　")!, offsetBy: 1)..<attribute.endIndex))))
                        self.translate(abilityDesc2, forKey: "abilityDesc2")
                        
                    }
                    else {
                        let abilityName2 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.index(before: attribute.indexOf("：")!)))))
                        self.translate(abilityName2, forKey: "abilityName2")
                        let abilityDesc2 = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("：")!, offsetBy: 1)..<attribute.endIndex))))
                        self.translate(abilityDesc2, forKey: "abilityDesc2")
                    }
                case "絆アビリティ":
                    if foundKizuna {
                        // pages have two types of brackets
                        if let _ = attribute.indexOf("("), let _ = attribute.indexOf("+") {
                            let kizunaName = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.startIndex..<attribute.indexOf("(")!))))
                            self.translate(kizunaName, forKey: "kizunaName")
                            let kizunaCost = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf("+")!, offsetBy: 1)..<attribute.index(attribute.indexOf("+")!, offsetBy: 2)))))
                            self.dict.updateValue(_: kizunaCost, forKey: "kizunaCost")
                            let kizunaDesc = String(NSString(string: attribute.substring(with: Range<String.Index>(attribute.index(attribute.indexOf(")　")!, offsetBy: 2)..<attribute.endIndex))))
                            self.translate(kizunaDesc, forKey: "kizunaDesc")

                            
                        }
                        else {
                            self.dict.updateValue("정보 없음", forKey: "kizunaName")
                            self.dict.updateValue("-", forKey: "kizunaCost")
                            self.dict.updateValue("정보 없음", forKey: "kizunaDesc")
                        }
                        
                    }
                    else {
                        self.dict.updateValue("정보 없음", forKey: "kizunaName")
                        self.dict.updateValue("-", forKey: "kizunaCost")
                        self.dict.updateValue("정보 없음", forKey: "kizunaDesc")
                    }
                

                case "出会いの物語", "運命の物語", "絆の物語":
                    
                    if attribute.contains("精霊石") {
                        let trailingString = attribute.substring(from: attribute.indexOf("Lv:")!)
                        
                        let chainStoneLevel = String(NSString(string: trailingString.substring(with: Range<String.Index>(trailingString.index(trailingString.indexOf("Lv:")!, offsetBy: 3)..<trailingString.index(before: trailingString.indexOf("/")!)))))
                        
                        if let cS = self.dict["chainStone"] {
                            self.dict.updateValue("\(cS), 레벨 \(chainStoneLevel)", forKey: "chainStone")
                        }
                        else {
                            self.dict.updateValue("레벨 \(chainStoneLevel)", forKey: "chainStone")
                        }
                        
                        
                    }
                case "チェインストーリー":
                    print(attribute)
                    if attribute.contains("章") && attribute.contains("】") {
                        self.translate(attribute, forKey: "chainStory")
                    }
                    else {
                        self.dict.removeValue(forKey: "chainStory")
                    }
                        
                    
                    
                case "入　手　方　法":
                    self.dict.updateValue(self.getTavern(attribute), forKey: "tavern")
                    
                default:
                    break
                }
            }
        }
        // WAIT FOR ALL TRANSLATIONS, THEN UPLOAD
        group.notify(queue: DispatchQueue.main, execute: { // Calls the given block when all blocks are finished in the group.
            // All blocks finished, do whatever you like.
            self.download.leave()
            
//            for (key, value) in self.dict {
//                print(key, value)
//            }
            self.uploadArcana()
        })
        
        
        
        
    }
    
    func updateMainImage(uid: String) {
        let ref = FIREBASE_REF.child("arcana/\(uid)")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let arcana = Arcana(snapshot: snapshot)

            if let imageURL = arcana!.imageURL {
                
                let imageCheckRef = STORAGE_REF.child("image/arcana/\(uid)/main.jpg")
                imageCheckRef.getMetadata(completion: { (metadata, error) in
                    
                    if (error == nil) {
                        // Uh-oh, an error occurred!

                        let url = URL(string: imageURL)
                        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print("DOWNLOAD MAIN ERROR")
                            }
                            
                            if let data = data {
                                print("DOWNLOADED MAIN!")
                                // upload to firebase storage.
                                
                                let arcanaImageRef = STORAGE_REF.child("image/arcana/\(uid)/main.jpg")
                                arcanaImageRef.putData(NSData(data: data) as Data, metadata: nil, completion: { (metadata, error) in
                                    if (error != nil) {
                                        print("ERROR OCCURED WHILE UPLOADING MAIN")
                                        // Uh-oh, an error occurred!
                                    } else {
                                        // Metadata contains file metadata such as size, content-type, and download URL.
                                        print("UPLOADED MAIN FOR \(arcana!.nameKR)")
                                        //let downloadURL = metadata!.downloadURL
                                    }
                                })
                                
                            }
                            
                        })
                        task.resume()
                        
                    } else {
                        // Metadata now contains the metadata for 'images/forest.jpg'
                        print("IMAGE EXISTS FOR \(arcana!.nameKR)")
                    }
                })
                
            }
            
        })
        
    }
    
    // Download inputted arcana
    @IBAction func downloadArcana(_sender: AnyObject) {
        dict.removeAll()
        download.enter()
        // TODO: Check if the page has #ui_wikidb. If it does, it is the new page, if it doesn't, it is the old page.
    
        let name = nameField.text!
        
        let encodedString = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        let encodedURL = URL(string: "\(self.baseURL)\(encodedString!)")
        
        // proceed to download
        
        print("PARSING...")
//        print(encodedURL!)
        
        let ref = FIREBASE_REF.child("arcana")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var exists = false
            
            for i in snapshot.children {
                let s = ((i as! DataSnapshot).value as! NSDictionary)["nameJP"] as! String
                if s == name {
                    exists = true
                }
                

            }
            
            guard exists == false else {
                print("ARCANA ALREADY EXISTS, STOPPING")
                return
            }
            
            do {
                let html = try String(contentsOf: encodedURL!, encoding: String.Encoding.utf8)
                
                
                // TODO: THERE ARE ACTUALLY 3 TYPES OF PAGES.
                // IF IT IS THE OLDEST, IT WONT HAVE <HR>. SO INSTEAD OF PARSING LIKE AN OLD PAGE, SEARCH ARCANADATA FOR BASIC ATTRIBUTES, THEN ONLY GET SKILL/ABILITIES FROM HTML.
                
                
                if html.contains("#ui_wikidb") {
                    //                self.downloadAttributes("new", html: html)
                    self.downloadAttributes("new", html: html)
//                    self.downloadImage("new", url: encodedURL!)
                    
                    
                }
                    
                else {
                    self.downloadAttributes("old", html: html)
//                    self.downloadImage("old", url: encodedURL!)
                    
                }
                
                
            }
                
            catch {
                print(error)
            }
            
            
            self.download.notify(queue: DispatchQueue.main, execute: {
                print("Finished translating.")
                
                self.loop.notify(queue: DispatchQueue.main, execute: { 
                    print("Finished uploading.")
//                    self.downloadIcon(_: self)
//                    downloadImages(nameJP: self.dict["nameJP"]!, imageURL: self.imageField.text!, iconURL: self.iconField.text!)
                    
                })
            })

        })
        
        
        
        
    }
    // Download one arcana
    func downloadArcana() {
        dict.removeAll()
        download.enter()
        // TODO: Check if the page has #ui_wikidb. If it does, it is the new page, if it doesn't, it is the old page.
        
        let encodedString = "最愛の友ミョルン".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        let encodedURL = URL(string: "\(self.baseURL)\(encodedString!)")
    
        // proceed to download
        
        print("PARSING...")
        print(encodedURL!)
        
        
        do {
            let html = try String(contentsOf: encodedURL!, encoding: String.Encoding.utf8)
            
            
            // TODO: THERE ARE ACTUALLY 3 TYPES OF PAGES.
            // IF IT IS THE OLDEST, IT WONT HAVE <HR>. SO INSTEAD OF PARSING LIKE AN OLD PAGE, SEARCH ARCANADATA FOR BASIC ATTRIBUTES, THEN ONLY GET SKILL/ABILITIES FROM HTML.
            
            
            if html.contains("#ui_wikidb") {
//                self.downloadAttributes("new", html: html)
                self.downloadAttributes("new", html: html)
                self.downloadImage("new", url: encodedURL!)
                
            }
                
            else {
                self.downloadAttributes("old", html: html)
                self.downloadImage("old", url: encodedURL!)
                
            }
            
            
        }
            
        catch {
            print(error)
        }
        
        
        self.download.notify(queue: DispatchQueue.main, execute: {
            print("Finished translating.")
            
            self.loop.notify(queue: DispatchQueue.main, execute: {
                print("Finished uploading.")
                
            })
        })
        
        
        
    }
    
    // Download all arcanas
    func downloadArcana(_ index: Int) {
        dict.removeAll()
        download.enter()
        // TODO: Check if the page has #ui_wikidb. If it does, it is the new page, if it doesn't, it is the old page.
 
        let encodedString = urls[index].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        let encodedURL = URL(string: "\(self.baseURL)\(encodedString!)")
    
        // first check if this exists in firebase
        let ref = FIREBASE_REF.child("arcana")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var exists = false
            
            for arcana in snapshot.children {
                if self.urls[index].contains(((arcana as! DataSnapshot).value as! NSDictionary)["nameJP"] as! String) {
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
                
//                print("PARSING...")
//                print(encodedURL!)
                
                
                do {
                    let html = try String(contentsOf: encodedURL!, encoding: String.Encoding.utf8)
                    
                    
                    // TODO: THERE ARE ACTUALLY 3 TYPES OF PAGES.
                    // IF IT IS THE OLDEST, IT WONT HAVE <HR>. SO INSTEAD OF PARSING LIKE AN OLD PAGE, SEARCH ARCANADATA FOR BASIC ATTRIBUTES, THEN ONLY GET SKILL/ABILITIES FROM HTML.
                    
                    
                    if html.contains("#ui_wikidb") {
                        self.downloadAttributes("new", html: html)
                        self.downloadImage("new", url: encodedURL!)
                        
                    }
                        
                    else {
                        self.downloadAttributes("old", html: html)
                        
                        self.downloadImage("old", url: encodedURL!)
                        
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
    
    func translate(_ value: String, forKey: String) {
        
        
//        print("translating \(value) for \(forKey)")
        
        let encodedString = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        
        if let encodedString = encodedString {
            group.enter()
            let url = URL(string: "https://www.googleapis.com/language/translate/v2?key=\(API_KEY)&q=\(encodedString)&source=ja&target=ko")
            
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                
                if let data = data {
                    let json = JSON(data: data)
                    
                    if let translatedText = json["data"]["translations"][0]["translatedText"].string {
                        
                        // get rid of &quot; and &lt &gt;
                        var t = translatedText.replacingOccurrences(of: "&quot;", with: " ")
                        t = t.replacingOccurrences(of: "&lt;", with: "")
                        t = t.replacingOccurrences(of: "&gt;", with: "")
                        // some have quotes at start, so remove whitespace
                        t = t.trimmingCharacters(in: .whitespacesAndNewlines)
                        // remove double spaces
                        t = t.replacingOccurrences(of: "◆ ", with: "")
                        t = t.replacingOccurrences(of: "  ", with: " ")
                        // remove space in front of %
                        t = t.replacingOccurrences(of: " %", with: "%")
                        t = t.replacingOccurrences(of: " )", with: ")")
                        t = t.replacingOccurrences(of: "副都", with: "부도")
                        t = t.replacingOccurrences(of: "WAVE", with: "웨이브")
                        t = t.replacingOccurrences(of: "進むたび", with: "진행될때마다")
                        t = t.replacingOccurrences(of: "】", with: "]")
                        
                        self.dict.updateValue(t, forKey: forKey)
                        //self.dict.updateValue(String(htmlEncodedString: final), forKey: key)
                        self.group.leave()
                    }

                    
                }

                
            })
            task.resume()
        }
        

    }
    
    func uploadArcana() {
        
        // TODO: upload arcana's uid to a tavern directory.
        loop.enter()
        let ref = FIREBASE_REF.child("arcana")
        
        
        print("STARTING UPLOAD PROCESS")
        
        
        // Check if arcana already exists
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var exists = false
            
            for i in snapshot.children {
                let s = ((i as! DataSnapshot).value as! NSDictionary)["nameJP"] as! String
                let d = self.dict["nameJP"]!
                if s == d {
                    exists = true
                }
                
            }
            
            if exists == true {
                print("\(self.dict["nameKR"])! ALREADY EXISTS")
                self.loop.leave()
            }
            
            else {
            
                let id = ref.childByAutoId().key
                // translate, put korean in dict values.
                self.dict["uid"] = id
                // TODO: check skillcount. if 1, just do normal. if 2 or 3, just upload the single skill2 or skill3 key-values.
                
                
                // Base Case: only 1 skill, 1 ability. Does not have nickname.
                var check = [String]()
                if self.dict["affiliation"] == nil {
                    self.dict["affiliation"] = ""
                }
                // TODO: Change base case to 1 skill 0 ability...
                guard let nKR = self.dict["nameKR"], let nJP = self.dict["nameJP"], let r = self.dict["rarity"], let g = self.dict["group"], let t = self.dict["tavern"], let a = self.dict["affiliation"], let c = self.dict["cost"], let w = self.dict["weapon"], let kN = self.dict["kizunaName"], var kC = self.dict["kizunaCost"], let kD = self.dict["kizunaDesc"], let sC = self.dict["skillCount"], let sN1 = self.dict["skillName1"], let sM1 = self.dict["skillMana1"], let sD1 = self.dict["skillDesc1"] else {
                    
                    
                    for (key, _) in self.dict {
                        check.append(key)
                    }
                    
                    print("ARCANA DICIONARY VALUE IS NIL")
                    return
                }
                
                if kC == "" {
                    kC = kC.fixEmptyString(rarity: r)
                }
                
                let checkedArray = check.sorted(by: {$0 < $1})
                for i in checkedArray {
                    print(i)
                }
//                guard let imageURL = self.dict["imageURL"] else {
//                    print("COULD NOT GET IMAGEURL FROM DICTIONARY")
//                    return
//                }
                
//                upload to tavernRef. only upload if it has a tavern.
                if t != "" {
                    
                    let tavernRef = FIREBASE_REF.child("tavern/\(self.getTavernRef(tavern: t))/\(id)")
                    tavernRef.setValue(true, withCompletionBlock: { (error, reference) in
                        
                    })
                    
                }
                
                // name-uid ref, for easy search purposes
                let nameID = FIREBASE_REF.child("name/\(id)")
                nameID.setValue("\(nKR)")
                
                
                let arcanaOneSkill = ["uid" : "\(id)", "nameKR" : "\(nKR)", "nameJP" : "\(nJP)", "rarity" : "\(r)", "class" : "\(g)", "tavern" : "\(t)", "affiliation" : "\(a)", "cost" : "\(c)", "weapon" : "\(w)", "kizunaName" : "\(kN)", "kizunaCost" : "\(kC)", "kizunaDesc" : "\(kD)", "skillCount" : "\(sC)", "skillName1" : "\(sN1)", "skillMana1" : "\(sM1)", "skillDesc1" : "\(sD1)", "numberOfViews" : 0] as [String : Any]
                
                let arcanaRef = ["\(id)" : arcanaOneSkill]
                
                // check for ability types
                self.findAbilities()
                
                ref.updateChildValues(arcanaRef, withCompletionBlock: { (error, reference) in
                    
                    print("UPLOADED \(nKR)")
                    downloadImages(nameJP: self.nameField.text!, imageURL: self.imageField.text!, iconURL: self.iconField.text!)
                    // check for chainStory, chainStone, dateAdded
                    let arcanaIDRef = FIREBASE_REF.child("arcana/\(id)")
                    if let d = self.dict["dateAdded"] {
                        arcanaIDRef.updateChildValues(["dateAdded" : "\(d)"])
                        
                    }
                    arcanaIDRef.updateChildValues(["numberOfLikes" : 0])
                    if let cStory = self.dict["chainStory"] {
                        arcanaIDRef.updateChildValues(["chainStory" : "\(cStory)"])
                        
                    }
                    if let cStone = self.dict["chainStone"] {
                        arcanaIDRef.updateChildValues(["chainStone" : "\(cStone)"])
                        
                    }
                    if !r.contains("1") {
                        if let aN1 = self.dict["abilityName1"], let aD1 = self.dict["abilityDesc1"] {
                            
                            let ability1 = ["abilityName1" : "\(aN1)", "abilityDesc1" : "\(aD1)"]
                            arcanaIDRef.updateChildValues(ability1)
                            
                        }
                    }
                    
                        // Check if arcana has 2 abilities
                        if r.contains("5") || r.contains("4") {
                            guard let aN2 = self.dict["abilityName2"], let aD2 = self.dict["abilityDesc2"] else {
                                print("ABILITY 2 NOT FOUND<<<")
                                return
                            }
                            let newArcanaRef = FIREBASE_REF.child("arcana/\(id)")
                            
                            // if let pa
                            if let pA = self.dict["partyAbility"] {
                                let pARef = ["partyAbility" : "\(pA)"]
                                newArcanaRef.updateChildValues(pARef)
                            }
                            let abilityRef = ["abilityName2" : "\(aN2)", "abilityDesc2" : "\(aD2)"]
                            self.loop.enter()
                            // Upload Ability 2
                            newArcanaRef.updateChildValues(abilityRef, withCompletionBlock: { (error, reference) in
                                self.loop.leave()
                            })
                            
                            // Check if arcana has at least 2 skills
                            if let sN2 = self.dict["skillName2"], let sM2 = self.dict["skillMana2"], let sD2 = self.dict["skillDesc2"] {
                                self.loop.enter()
                                switch (sC) {
                                case "2":
                                    
                                    let skill2 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)"]
                                    newArcanaRef.updateChildValues(skill2, withCompletionBlock: { (error, reference) in
                                        self.loop.leave()
                                    })
                                    
                                case "3":
                                    
                                    if let sN2 = self.dict["skillName2"], let sM2 = self.dict["skillMana2"], let sD2 = self.dict["skillDesc2"], let sN3 = self.dict["skillName3"], let sM3 = self.dict["skillMana3"], let sD3 = self.dict["skillDesc3"] {
                                        let skill3 = ["skillName2" : "\(sN2)", "skillMana2" : "\(sM2)", "skillDesc2" : "\(sD2)", "skillName3" : "\(sN3)", "skillMana3" : "\(sM3)", "skillDesc3" : "\(sD3)"]
                                        newArcanaRef.updateChildValues(skill3, withCompletionBlock: { (error, reference) in
                                            self.loop.leave()
                                        })
                                        
                                    }
                                    
                                default:
                                    
                                    self.loop.leave()
                                    break
                                    
                                }
                                
                            }
                            
                        }
                        // rarity 1,2,3. only has 1 ability
                        else {
                        }
                        
                        self.loop.leave()
//                        })
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
                if aD1.contains("마나 슬롯") && aD1.contains("속도") && !aD1.contains("이동 속도") {
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
                if aD1.contains("WAVE가 시작 할 때마다") {
                    if (aD1.contains("회복한다") || aD1.contains("회복하고")) && (aD1.contains("낮은 동료") || aD1.contains("가까이") || aD1.contains("아군 전체")) {
                        let abilityRef = FIREBASE_REF.child("partyHealAbility").child(id)
                        abilityRef.setValue(true)
                    }

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
                if aD2.contains("마나 슬롯") && aD2.contains("속도") && !aD2.contains("이동 속도") {
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
                if aD2.contains("WAVE가 시작 할 때마다") {
                    if (aD2.contains("회복한다") || aD2.contains("회복하고")) && (aD2.contains("낮은 동료") || aD2.contains("가까이") || aD2.contains("아군 전체")) {
                        let abilityRef = FIREBASE_REF.child("partyHealAbility").child(id)
                        abilityRef.setValue(true)
                    }
                    
                }
            }
            if let k = self.dict["kizunaDesc"] {
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
                if (k.contains("슬로우") || k.contains("스러운")) && (k.contains("않는다") || k.contains("안고")) {
                    let kizunaRef = FIREBASE_REF.child("slowImmuneKizuna/\(id)")
                    kizunaRef.setValue(true)
                }
                if k.contains("WAVE가 시작 할 때마다") {
                    if (k.contains("회복한다") || k.contains("회복하고")) && (k.contains("낮은 동료") || k.contains("가까이") || k.contains("아군 전체")) {
                        let kizunaRef = FIREBASE_REF.child("partyHealKizuna").child(id)
                        kizunaRef.setValue(true)
                    }
                    
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
        
        let taverns = ["副都", "聖都", "賢者の塔", "迷宮山脈", "湖都", "精霊島", "炎の九領", "海風の港", "夜明けの大海", "ケ者の大陸", "罪の大陸", "薄命の大陸", "鉄煙の大陸", "年代記", "書架", "レムレス島", "華撃団", "魔神", /*"ガチャ",*/ "グ交換", "聖王国"]
        var tav = ""
    
        for (index, t) in taverns.enumerated() {
            if string.contains(t) {
                if string.contains("3部") && t != "聖王国" {
                    tav = "\(taverns[index])2"
                }
                else {
                    tav = taverns[index]
                }
                
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
        case "湖都":
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
            return "수인의대륙"
        case "罪の大陸":
            return "죄의대륙"
        case "薄命の大陸":
            return "박명의대륙"
        case "鉄煙の大陸":
            return "철연의대륙"
        case "年代記":
            return "연대기대륙"
        case "書架":
            return "서가"
        case "レムレス島":
            return "레무레스섬"
        case "華撃団":
            return "화격단"
        case "魔神":
            return "마신"
        case "義勇軍":
            return "의용군"
        case "リングガチャ":
            return "링가챠"
        case "グ交換":
            return "링교환"
            
            // 3부 주점
        case "聖王国":
            return "성왕국"
        case "賢者の塔2":
            return "현자의탑 3부"
        case "湖都2":
            return "호수도시 3부"
        case "精霊島2":
            return "정령섬 3부"
        case "炎の九領2":
            return "화염구령 3부"
        default:
            return ""
        }
        
    }

    func getTavernRef(tavern: String) -> String {
        
        switch tavern {
            
        case "부도":
            return "capital"
        case "성도":
            return "holy"
        case "현자의탑":
            return "sage"
        case "미궁산맥":
            return "maze"
        case "호수도시":
            return "lake"
        case "정령섬":
            return "soul"
        case "화염구령":
            return "fire"
        case "해풍의항구":
            return "seaBreeze"
        case "새벽대해":
            return "daybreakOcean"
        case "수인의대륙":
            return "beast"
        case "죄의대륙":
            return "sin"
        case "박명의대륙":
            return "ephemerality"
        case "철연의대륙":
            return "iron"
        case "연대기대륙":
            return "chronicle"
        case "서가":
            return "book"
        case "레무레스섬":
            return "lemures"
        case "마신":
            return "demon"
        case "링가챠":
            return "ringGacha"
        case "링교환":
            return "ringChange"
        default:
            return ""
        }
        
    }
    
    func getAffiliation(_ string: String) -> String {
        // two types, second is for old arcana in text file
        switch string {
        case "副都":
            return "부도"
        case "聖都":
            return "성도"
        case "賢者の塔", "賢者":
            return "현자의탑"
        case "迷宮山脈", "迷宮":
            return "미궁산맥"
        case "湖都":
            return "호수도시"
        case "精霊島", "海風":
            return "정령섬"
        case "九領":
            return "화염구령"
        case "大海":
            return "대해"
        case "ケ者の大陸", "ケ者":
            return "수인의대륙"
        case "罪の大陸", "罪":
            return "죄의대륙"
        case "薄命の大陸", "薄命":
            return "박명의대륙"
        case "鉄煙の大陸", "鉄煙":
            return "철연의대륙"
        case "年代記の大陸":
            return "연대기대륙"
        case "レムレス島":
            return "레무레스섬"
        case "華撃団":
            return "화격단"
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
        let data: Data? = try? Data(contentsOf: URL(fileURLWithPath: path!))
        //print(data)
        do {
            let jsonObject : Any! =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            let json = JSON(jsonObject)
            var contains = false
            
            for (_, subJson) : (String, JSON) in json["array"] {
                
                // Checking for nickname because of ver 2.
                if string.contains(subJson["nickname"].stringValue) || string.contains(subJson["name"].stringValue) {
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
                    nickJPQuotes = nickJPQuotes.replacingOccurrences(of: "“", with: " ")
                    nickJPQuotes = nickJPQuotes.replacingOccurrences(of: "”", with: " ")
                    // some have quotes at start, so remove whitespace
                    let nickJP = nickJPQuotes.trimmingCharacters(in: .whitespacesAndNewlines)
                    let affiliation = subJson["syozoku"].stringValue
                    self.translate(nameJP, forKey: "nameKR")
                    self.translate(nickJP, forKey: "nickKR")
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
        
//        let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
        
        
        
        //print("SEARCHING FOR \(string)")
        
        let path = Bundle.main.path(forResource: ".//arcanaData", ofType: "txt")
        let data: Data? = try? Data(contentsOf: URL(fileURLWithPath: path!))
        
        do {
            let jsonObject : Any! =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
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

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
        case nameField:
            iconField.becomeFirstResponder()
            
        case iconField:
            downloadArcana(_sender: self)
        default:
            break
        }
        
        
        return true
    }
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
    }

    func uploadImageWithURL(uid: String, imageURL: String) {
        
        
        
            let url = URL(string: imageURL)
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print("DOWNLOAD IMAGE ERROR")
                }
                
                if let data = data {

                    // upload to firebase storage.
                    
                    let ref = STORAGE_REF.child("image/arcana/\(uid)/main.jpg")
                    ref.putData(NSData(data: data) as Data, metadata: nil, completion: { (metadata, error) in
                        
                        if (error != nil) {
                            print("ERROR OCCURED WHILE UPLOADING IMAGE)")
                            // Uh-oh, an error occurred!
                        } else {
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            print("UPLOADED IMAGE")
                            
                            //let downloadURL = metadata!.downloadURL
                        }
                    })
                    
                }
                
            })
            task.resume()
        
        
    }
    
    func cleanIDS() {
        let abilityRef = FIREBASE_REF.child("treasureKizuna")
        abilityRef.observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            for id in uid {
                self.group.enter()

                let ref = FIREBASE_REF.child("arcana/\(id)")
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists() == false {
                        print("removing \(id)")
                        abilityRef.child("\(id)").removeValue()
                        

                    }
                    self.group.leave()
                })
                
                
            }
            
            self.group.notify(queue: DispatchQueue.main, execute: {
                print("DONE")
            })
            
        })
    }
    
    func findAbility() {
        
        let ref = FIREBASE_REF.child("arcana")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            let snapDict = snapshot.value as! [String:AnyObject]
            for arcana in snapDict {
                
//                let arcana = i as? NSDictionary
                let uid = arcana.value["uid"] as! String
                let ability1 = arcana.value["abilityDesc1"] as? String
                let ability2 = arcana.value["abilityDesc2"] as? String
                let kizuna = arcana.value["kizunaDesc"] as? String
                
//                if let ability1 = ability1 {
//                    if (ability1.contains("슬로우") || ability1.contains("스러운")) && (ability1.contains("않는다") || ability1.contains("안고")) {
//                        let abilityRef = FIREBASE_REF.child("slowImmuneKizuna/\(uid)")
//                        print("adding \(uid)")
//                        abilityRef.setValue(true)
//                    }
//                }
//                if let ability2 = ability2 {
//                    if (ability2.contains("슬로우") || ability2.contains("스러운")) && (ability2.contains("않는다") || ability2.contains("안고")) {
//                        let abilityRef = FIREBASE_REF.child("slowImmuneKizuna/\(uid)")
//                        print("adding \(uid)")
//                        abilityRef.setValue(true)
//                    }
//                }
                if let kizuna = kizuna {
                    if (kizuna.contains("슬로우") || kizuna.contains("스러운")) && (kizuna.contains("않는다") || kizuna.contains("안고")) {
                        let abilityRef = FIREBASE_REF.child("slowImmuneKizuna/\(uid)")
                        print("adding \(uid)")
                        abilityRef.setValue(true)
                    }
                }

            }
        })
    }
    
    func resetViews() {
        let ref = FIREBASE_REF.child("arcana")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            for i in uid {
                ref.child("\(i)/numberOfViews").setValue(0)
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
    
    func addNumberOfLikes() {
        let ref = FIREBASE_REF.child("arcana")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            for i in uid {
                ref.child("\(i)/numberOfLikes").setValue(0)
            }
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
//        translateWaveUp()
//        moveAbilityRefs()
//        updateAbility(ability: PartyHeal())
//        updateAbility(ability: StunImmune(), conditions: true)
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

extension String {
    func indexOf(_ string: String) -> String.Index? {
        return range(of: string, options: .literal, range: nil, locale: nil)?.lowerBound
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

