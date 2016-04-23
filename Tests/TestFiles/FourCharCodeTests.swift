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

    func testCodeAndDecodeAreEqual() {
        if  let code = "wht?".code,
            let decode = code.codeString {
            XCTAssertEqual("wht?", decode, "Could not encode and decode 'wht?'")
        } else {
            XCTFail("Either 'code' or 'decode' was nil.")
        }
    }
    
    func testEmptyStringCodeIsNil() {
        XCTAssertNil("".code, "Empty string does not produce nil value.")
    }
    
    func testLongStringIsNil() {
        XCTAssertNil("5char".code, "String with length of five chars does not produce nil value.")
    }
    
    func testNonASCIIChar31IsNil() {
        XCTAssertNil("\u{ff}xxx".code, "Character outside ASCII range does not produce nil value.")
    }
    
    func testNONASCIIChar127IsNil() {
        XCTAssertNil("\u{7f}xxx".code)
    }
    
    func testHighComposedUnicodeCharIsNil() {
        XCTAssertNil("\u{2190}x".code, "Unicode value '0x2190' does not produce nil value.")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
}
