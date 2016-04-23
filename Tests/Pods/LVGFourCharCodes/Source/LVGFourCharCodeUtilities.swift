//
//  LVGFourCharCodeUtilities.swift
//  LVGFourCharCodeUtilities
//
//  Created by doof nugget on 4/14/16.
//  Copyright © 2016 letvargo. All rights reserved.
//

import Foundation

public protocol CodeStringConvertible {
    
    var codeString: String? { get }
}

extension CodeStringConvertible {
    
    public var codeString: String? {
        
        let size = sizeof(self.dynamicType)
        
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

public protocol CodedPropertyType {
    var rawValue: UInt32 { get }
    var code: UInt32 { get }
    var domain: String { get }
    var shortDescription: String { get }
}

extension CodedPropertyType {
    
    public var description: String {
        
        var base = "\(self.domain): \(self.shortDescription)\n\tCode: \(self.code)"
        
        if let codeString = self.code.codeString {
            base.appendContentsOf(" ('\(codeString)')")
        }
        
        return base
    }
    
    public var rawValue: UInt32 {
        return self.code
    }
}

public protocol CodedErrorType: ErrorType, CustomStringConvertible, RawRepresentable {
    
    var domain: String { get }
    var code: OSStatus { get }
    var shortDescription: String { get }
    var message: String? { get }
    
    static func check(status: OSStatus, message: String) throws
    
    init(status: OSStatus, message: String?)
}

extension CodedErrorType {
    
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
    
    public var rawValue: OSStatus {
        return self.code
    }
    
    public init(rawValue: OSStatus) {
        self.init(status: rawValue, message: nil)
    }
    
    public static func check(status: OSStatus, message: String) throws {
        
        guard
            status == noErr
            else
        { throw self.init(status: status, message: message) }
    }
}

extension String {

    var code: UInt32? {
    
        func pointsToUInt32(points: UnsafePointer<UInt8>) -> UInt32 {
            return UnsafePointer<UInt32>(points).memory
        }
    
        let codePoints = Array(self.utf8)
        
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