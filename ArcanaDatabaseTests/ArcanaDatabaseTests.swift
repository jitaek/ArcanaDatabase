//
//  ArcanaDatabaseTests.swift
//  ArcanaDatabaseTests
//
//  Created by Jitae Kim on 12/7/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import XCTest
import UIKit
@testable import ArcanaDatabase

class ArcanaDatabaseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        testGetTavern()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetTavern() {
        
        let mock = ArcanaDatabase()
        let testString = "3部主人公フェス、3部湖都ガチャ"

        let answer = "호수도시2"
        let result = mock.getTavern(testString)
        
        XCTAssert(answer == result, "Got \(result) instead of \(answer)")
        
    }

}
