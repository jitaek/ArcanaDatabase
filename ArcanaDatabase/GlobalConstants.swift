//
//  GlobalConstants.swift
//  Chain
//
//  Created by Jitae Kim on 8/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
//import Polyglot

let API_KEY = "AIzaSyCYG0yJH_q0KBhYWzSY6gxcoHdAjEqJK3U"

let FIREBASE_REF = FIRDatabase.database().reference()
let STORAGE_REF = FIRStorage.storage().reference()

//let example = "https://xn--eckfza0gxcvmna6c.gamerch.com/年代記の剣士リヴェラ"
//let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
//let arcanaURL = "強欲な花タチアナ"
//
//let encodedString = arcanaURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
//
//let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")

let SCREENWIDTH = UIScreen.main.bounds.width
let SCREENHEIGHT = UIScreen.main.bounds.height

let DOWNLOADER = ImageDownloader(
    configuration: ImageDownloader.defaultURLSessionConfiguration(),
    downloadPrioritization: .fifo,
    maximumActiveDownloads: 4,
    imageCache: AutoPurgingImageCache()
)

let IMAGECACHE = AutoPurgingImageCache(
    memoryCapacity: 100 * 1024 * 1024,
    preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
)


// Colors
let WARRIORCOLOR = UIColor(red:1.0, green:0.23, blue:0.19, alpha:1.0)
let KNIGHTCOLOR = UIColor(red:0.0, green:0.48, blue:1.0, alpha:1.0)
let ARCHERCOLOR = UIColor(red:1.0, green:0.8, blue:0.0, alpha:1.0)
let MAGICIANCOLOR = UIColor(red:0.35, green:0.34, blue:0.84, alpha:1.0)
let HEALERCOLOR = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1.0)
let salmonColor = UIColor(red:0.92, green:0.65, blue:0.63, alpha:1.0)
let darkNavyColor = UIColor(red:0.18, green:0.22, blue:0.29, alpha:1.0)
let lightNavyColor = UIColor(red:0.23, green:0.29, blue:0.37, alpha:1.0)
let darkGrayColor = UIColor(red:0.53, green:0.59, blue:0.65, alpha:1.0)
let lightGrayColor = UIColor(red:0.86, green:0.88, blue:0.9, alpha:1.0)
let greenColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1.0)
let lightGreenColor = UIColor(red:0.41, green:0.64, blue:0.51, alpha:1.0)
let textGrayColor = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.0)



//let TRANSLATOR = Polyglot(clientId: "ChainChronicle1126", clientSecret: "hCRxD8K8n4SkJ+m/yQtV1cFxm/JG4JfjzMFptQSBwWE=")

