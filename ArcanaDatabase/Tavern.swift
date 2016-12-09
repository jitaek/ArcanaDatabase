//
//  Tavern.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 12/7/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation

enum Tavern {
    
    // 1부 주점
    enum capital {
        static let KR = "부도"
        static let JP = "副都"
        static let EN = "capital"
    }
    
    enum holy {
        static let KR = "성도"
        static let JP = "聖都"
        static let EN = "holy"
    }
    
    enum sage {
        static let KR = "현자의탑"
        static let KRshort = "현탑"
        static let JP = "賢者の塔"
        static let EN = "sage"
    }
    
    enum maze {
        static let KR = "미궁산맥"
        static let KRshort = "미궁"
        static let JP = "迷宮山脈"
        static let EN = "maze"
    }
    
    enum lake {
        static let KR = "호수도시"
        static let KRshort = "호도"
        static let JP = "湖都"
        static let EN = "lake"
    }
    
    enum soul {
        static let KR = "정령섬"
        static let JP = "精霊島"
        static let EN = "soul"
    }
    
    enum fire {
        static let KR = "화염구령"
        static let KRshort = "구령"
        static let JP = "炎の九領"
        static let EN = "fire"
    }
    
    enum seaBreeze {
        static let KR = "해풍의항구"
        static let JP = "海風の港"
        static let EN = "seaBreeze"
    }
    
    // 2부 주점

    enum daybreakOcean {
        static let KR = "새벽대해"
        static let JP = "夜明けの大海"
        static let EN = "daybreakOcean"
    }

    enum beast {
        static let KR = "수인의대륙"
        static let KRshort = "수인"
        static let JP = "ケ者の大陸"
        static let EN = "beast"
    }

    enum sin {
        static let KR = "죄의대륙"
        static let KRshort = "죄"
        static let JP = "罪の大陸"
        static let EN = "sin"
    }

    enum ephemerality {
        static let KR = "박명의대륙"
        static let KRshort = "박명"
        static let JP = "薄命の大陸"
        static let EN = "ephemerality"
    }

    enum iron {
        static let KR = "철연의대륙"
        static let KRshort = "철연"
        static let JP = "鉄煙の大陸"
        static let EN = "iron"
    }

    enum chronicle {
        static let KR = "연대기대륙"
        static let JP = "年代記"
        static let EN = "chronicle"
    }
    
    enum book {
        static let KR = "서가"
        static let JP = "書架"
        static let EN = "book"
    }

    enum lemures {
        static let KR = "레무레스섬"
        static let KRshort = "레무"
        static let JP = "レムレス島"
        static let EN = "lemures"
    }

    // 3부 주점
    
    enum holyKingdom {
        static let KR = "성왕국"
        static let JP = "聖王国"
        static let EN = "holyKingdom"
    }
    
    enum sage2 {
        static let KR = "현자의탑"
        static let JP = "賢者の塔"
        static let EN = "sage3"
    }
    
    
    enum lake2 {
        static let KR = "호수도시"
        static let JP = "湖都"
        static let EN = "lake"
    }
    
    enum soul2 {
        static let KR = "정령섬"
        static let JP = "精霊島"
        static let EN = "soul"
    }
    
    enum fire2 {
        static let KR = "화염구령"
        static let KRshort = "구령"
        static let JP = "炎の九領"
        static let EN = "fire"
    }

    
    //    enum flower {
    //        static let KR = "화격단"
    //        static let JP = "華撃団"
    //        static let EN = "sakura"
    //    }

}




/*


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
*/
