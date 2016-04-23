//
//  FourCharCodeTests.swift
//  Tests
//
//  Created by doof nugget on 4/23/16.
//
//

import XCTest
import LVGFourCharCodes
import AudioToolbox

class FourCharCodeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCodeStringAgainstKnownValue() {
        if  let codeString = kAudioServicesBadPropertySizeError.codeString {
            XCTAssertEqual(codeString, "!siz", "codeString property did not compute correct value of '!siz'")
        } else {
            XCTFail("codeString was 'nil' for value with known FourCharCode '!siz'.")
        }
    }
    
    func testInvalidValueReturnsNilCodeString() {
        let value: UInt32 = 0
        XCTAssertNil(value.codeString, "UInt32 value of 0 failed to return a nil codeString.")
    }
    
    func testNegativeValueReturnsNilCodeString() {
        let value: Int32 = -1500
        XCTAssertNil(value.codeString, "Int32 value of -1500 failed to return a nil codeString.")
    }
    
    func testValueLessThan4BytesReturnsNilCodeString() {
        let value: UInt32 = 0b00000000001111110011111100111111
        XCTAssertNil(value.codeString, "UInt32 value not 4-bytes long failed to return a nil codeString.")
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
