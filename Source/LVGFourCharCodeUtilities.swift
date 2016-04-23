//
//  LVGFourCharCodeUtilities.swift
//  LVGFourCharCodeUtilities
//
//  Created by doof nugget on 4/14/16.
//  Copyright © 2016 letvargo. All rights reserved.
//

import Foundation

// MARK: CodeStringConvertible - Definition

/**

 Converts a 4-byte integer type to a 4-character `String`.
 
 By default, only `UInt32` and `Int32` conform to this protocol.
 Various `typealias`es for these two types will also conform, including
 `OSStatus` and `FourCharCode`.
 
 Many Apple APIs have error codes or constants that can be converted
 to a 4-character string. Valid 4-character code strings are exactly
 4 characers long and every character is between ASCII values 32..<127.
 
 For example, the constant `kAudioServicesBadPropertySizeError` defined in
 Audio Toolbox has a 4-character code string '!siz'. Many `OSStatus` error
 codes have 4-character code strings associated with them, and these
 can be useful for debugging.
 
 **Properties:**
 
 var codeString: String? { get }

 */

public protocol CodeStringConvertible {
    var codeString: String? { get }
}

extension CodeStringConvertible {

    /**
    
     A `String`, exactly 4 characters in length, that represents 
     the 'FourCharCode' of the value.
     
     Many Apple APIs have error codes or constants that can be converted
     to a 4-character string. Valid 4-character code strings are exactly
     4 characers long and every character is between ASCII values 32..<127.
     
     For example, the constant `kAudioServicesBadPropertySizeError` defined in
     Audio Toolbox has a 4-character code string '!siz'. Many `OSStatus` error
     codes have 4-character code strings associated with them, and these
     can be useful for debugging.
     
     If the value that this is called on is not exactly 4 bytes in size,
     or if any of the bytes (interpreted as a `UInt8`) does not represent an
     ASCII value contained in `32..<127`, the `codeString` property will be `nil`.
    
     */
    
    public var codeString: String? {
        
        let size = sizeof(self.dynamicType)
        
        guard size == 4 else { fatalError("Only types whose size is exactly 4 bytes can conform to `CodeStringConvertible`") }
        
        func parseBytes(value: UnsafePointer<Void>) -> [UInt8]? {
            
            let ptr = UnsafePointer<UInt8>(value)
            var bytes = [UInt8]()
            
            for index in (0..<size).reverse() {
                
                let byte = ptr.advancedBy(index).memory
                
                if (32..<127).contains(byte) {
                    
                    bytes.append(byte)
                    
                } else {
                    
                    return nil
                }
            }
            
            return bytes
        }
        
        if  let bytes = parseBytes([self]),
            let output = NSString(
                bytes: bytes
                , length: size
                , encoding: NSUTF8StringEncoding) as? String {
            
            return output
        }
        
        return nil
    }
}

extension OSStatus: CodeStringConvertible { }

extension UInt32: CodeStringConvertible { }

// MARK: CodedPropertyType - Definition

/**

 A protocol for API-defined properties that are represented by a
 constant `UInt32` value.
 
 **Properties:**
 
 `var rawValue: UInt32 { get }`
 
 By default, this is the same as the `code` property.
 
 `var code: UInt32 { get }`
 
 The numeric value of the constant that represents the property. The 
 'FourCharCode' for the value can be accessed through its `codeString` property.
 
 `var domain: String { get }`
 
 The domain should be the API that defines the property. For example, the
 properties defined in System Sound Services will have the domain 'System
 Sound Services Property'.
 
 `var shortDescription: String { get }`
 
 A short description of the property.
 
 `var description: String { get }`
 
 The printable, formatted description of the property. The `description` 
 will include information about the `domain`,
 the `shortDescription` and the `code` properties. If the `code` property
 represents a valid 'FourCharCode', the `codeString` will also be printed.

 */

public protocol CodedPropertyType: CustomStringConvertible, RawRepresentable {
    var rawValue: UInt32 { get }
    var code: UInt32 { get }
    var domain: String { get }
    var shortDescription: String { get }
    init?(code: UInt32)
}

extension CodedPropertyType {

    /**
     
     The printable, formatted description of the property.
     
     The `description` will include information about the `domain`,
     the `shortDescription` and the `code` properties. If the `code` property
     represents a valid 'FourCharCode', the `codeString` will also be printed.
     
     */
    
    public var description: String {
        
        var base = "\(self.domain): \(self.shortDescription)\n\tCode: \(self.code)"
        
        if let codeString = self.code.codeString {
            base.appendContentsOf(" ('\(codeString)')")
        }
        
        return base
    }
    
    /**
    
     The `rawValue` of the property.
     
     The default implementation returns the same value as `code`.
    
     */
    
    public var rawValue: UInt32 {
        return self.code
    }
    
    /**
    
     Initialize a `CodedPropertyType` by its `rawValue`.
     
     The default implementation calls `self.init(code: rawValue)`.
    
     */
    
    public init?(rawValue: UInt32) {
        self.init(code: rawValue)
    }
}

// MARK: CodedErrorType - Definition

/**
 
 A protocol that can be used to convert API-defined `OSStatus` error codes
 into a Swift `ErrorType` with a useful `description` that can be used for
 debugging.
 
 **Properties:**
 
 `var rawValue: UInt32 { get }`
 
 By default, this is the same as the `code` property.
 
 `var code: UInt32 { get }`
 
 The numeric value of the constant that represents the property. The
 'FourCharCode' for the value can be accessed through its `codeString` property.
 
 `var domain: String { get }`
 
 The domain should be the API that defines the property. For example, the
 properties defined in System Sound Services will have the domain 'System
 Sound Services Property'.
 
 `var shortDescription: String { get }`
 
 A short description of the property.
 
 `var message: String { get }`
 
 A message that can provide information about the context from which the 
 error was thrown.
 
 `var description: String { get }`
 
 The printable, formatted description of the error. The 
 `description` will include information about the `domain`,
 the `shortDescription`, a `message`, and the `code` properties. If the
 `code` property represents a valid 'FourCharCode', the `codeString`
 will also be printed.
 
 */

public protocol CodedErrorType: ErrorType, CustomStringConvertible, RawRepresentable {
    
    var domain: String { get }
    var code: OSStatus { get }
    var shortDescription: String { get }
    var message: String? { get }
    
    static func check(status: OSStatus, message: String) throws
    
    init(status: OSStatus, message: String?)
}

extension CodedErrorType {
    
    /**
     
     The printable, formatted description of the error.
     
     The `description` will include information about the `domain`,
     the `shortDescription`, a `message`, and the `code` properties. If the 
     `code` property represents a valid 'FourCharCode', the `codeString` 
     will also be printed.
     
     */
    
    public var description: String {
        
        var base = "\(self.domain): \(self.shortDescription)."
        if let message = self.message {
            base.appendContentsOf("\n\tMessage: \(message)")
        }
        
        base.appendContentsOf("\n\tCode: \(self.code)")
        
        if let codeString = self.code.codeString {
            base.appendContentsOf(" ('\(codeString)')")
        }
        
        return base
    }
    
    /**
     
     The `rawValue` of the property.
     
     The default implementation returns the same value as `code`.
     
     */
    
    public var rawValue: OSStatus {
        return self.code
    }
    
    /**
     
     Initialize a `CodedErrorType` by its `rawValue`.
     
     The default implementation calls `self.init(status: rawValue, message: "No message.")`.
     
     */
    
    public init(rawValue: OSStatus) {
        self.init(status: rawValue, message: "No message.")
    }
    
    /**
    
     Checks the `status` and throws a `CodedErrorType` with the `message`
     if `status != noErr`.
     
     - parameter status: The `OSStatus` value that should be checked.
     - parameter message: A message that can provide information about the
     context from which the error is being thrown.
     
     - throws: `Self`, a `CodedErrorType`.
     
     */
    
    public static func check(status: OSStatus, message: String) throws {
        
        guard
            status == noErr
            else
        { throw self.init(status: status, message: message) }
    }
}

// MARK: String - Extension adding the code property

extension String {

    public var code: UInt32? {
    
        func pointsToUInt32(points: UnsafePointer<UInt8>) -> UInt32 {
            return UnsafePointer<UInt32>(points).memory
        }
    
        let codePoints = Array(self.utf8.reverse())
        
        guard
            codePoints.count == 4
        else {
            return nil
        }
        
        guard
            codePoints.reduce(true, combine: { $0 && (32..<127).contains($1) })
        else {
            return nil
        }
        
        return pointsToUInt32(codePoints)
    }
}