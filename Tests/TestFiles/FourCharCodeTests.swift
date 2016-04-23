//
//  FourCharCodeTests.swift
//  Tests
//
//  Created by doof nugget on 4/23/16.
//
//

import XCTest
import LVGFourCharCodes

class FourCharCodeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let i: Int32 = KAUTH_ENDIAN_DISK
        print(i.codeString)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
