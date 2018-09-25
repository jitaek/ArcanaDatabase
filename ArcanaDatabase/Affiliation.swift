//
//  Affiliation
//  ArcanaDatabase
//
//  Created by Jitae Kim on 12/7/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation


enum Affiliation {
    
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
        static let JPshort = "賢者"
        static let EN = "sage"
    }
    
    enum maze {
        static let KR = "미궁산맥"
        static let KRshort = "미궁"
        static let JP = "迷宮山脈"
        static let JPshort = "迷宮"
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
    
    enum sea {
        static let KR = "대해"
        static let JP = "大海"
        static let EN = "sea"
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
    
    enum traveler {
        static let KR = "여행자"
        static let JP = "旅人"
        static let EN = "traveler"
    }
    
    enum volunteer {
        static let KR = "의용군"
        static let JP = "義勇軍"
        static let EN = "volunteer"
    }
    
    enum demon {
        static let KR = "마신"
        static let JP = "魔神"
        static let EN = "demon"
    }
    
    enum flower {
        static let KR = "화격단"
        static let JP = "華撃団"
        static let EN = "sakura"
    }
    
}

func getAffiliation(string: String) -> String {

    switch string {
    case Affiliation.capital.JP:
        return Affiliation.capital.KR
    case Affiliation.holy.JP:
        return Affiliation.holy.KR
    case Affiliation.sage.JP, Affiliation.sage.JPshort:
        return Affiliation.sage.KR
    case Affiliation.maze.JP, Affiliation.maze.JPshort:
        return Affiliation.maze.JP
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
