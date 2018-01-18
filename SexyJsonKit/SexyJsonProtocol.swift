//
//  SexyJsonProtocol.swift
//  SexyJson
//
//  Created by WHC on 17/5/14.
//  Copyright © 2017年 WHC. All rights reserved.
//
//  Github <https://github.com/netyouli/SexyJson>
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#else
    import AppKit
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
    public typealias SexyColor = UIColor
#else
    public typealias SexyColor = NSColor
#endif

//MARK: - Public protocol -

public protocol _SexyJsonBase {
    func sexyToValue() -> Any?
}

public protocol _SexyJsonInitBase: _SexyJsonBase {
    init()
}

public protocol _SexyJsonBasicType: _SexyJsonBase {
    static func sexyTransform(_ value: Any?) -> Self?
}

public protocol _SexyJsonObjectType: _SexyJsonInitBase {}
public protocol SexyJsonBasicType: _SexyJsonBasicType{}
public protocol SexyJsonCollectionType: _SexyJsonBasicType{}
public protocol SexyJsonEnumType: SexyJsonBasicType{}
public protocol SexyJsonObjectType: _SexyJsonObjectType {
    static func _sexyTransform(_ value: Any?) -> Any?
}

public protocol SexyJson: _SexyJsonInitBase {
    mutating func sexyMap(_ map: [String : Any]) -> Void
}


public extension SexyJson {
    public func sexyToValue() -> Any? {
        let mirror = Mirror(reflecting: self)
        var jsonMap = [String: Any]()
        var children = [(label: String?, value: Any)]()
        let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children)!
        children += mirrorChildrenCollection
        var currentMirror = mirror
        while let superclassChildren = currentMirror.superclassMirror?.children {
            let randomCollection = AnyRandomAccessCollection(superclassChildren)!
            children += randomCollection
            currentMirror = currentMirror.superclassMirror!
        }
        children.enumerated().forEach({ (index, element) in
            if let key = element.label, !key.isEmpty {
                if let value = (element.value as? _SexyJsonBase)?.sexyToValue() {
                    jsonMap[key] = value
                }
            }
        })
        return jsonMap
    }
}

extension ImplicitlyUnwrappedOptional: _SexyJsonBase {
    public func sexyToValue() -> Any? {
        return self == nil ? nil : (self! as? _SexyJsonBase)?.sexyToValue()
    }
}

extension Optional: _SexyJsonBase {

    public func sexyToValue() -> Any? {
        return self == nil ? nil : (self! as? _SexyJsonBase)?.sexyToValue()
    }
}

//MARK: - Internal protocol -

public protocol SexyJsonBoolType:SexyJsonBasicType {}

extension SexyJsonBoolType {
    public static func sexyTransform(_ object: Any?) -> Bool? {
        switch object {
        case let str as NSString:
            let lowerCase = str.lowercased
            if ["0", "false"].contains(lowerCase) {
                return false
            }
            if ["1", "true"].contains(lowerCase) {
                return true
            }
            return false
        case let num as NSNumber:
            return num.boolValue
        default:
            return false
        }
    }
    
    public func sexyToValue() -> Any? {
        return self
    }
}

public protocol SexyJsonFloatType:SexyJsonBasicType, LosslessStringConvertible {
    init(_ number: NSNumber)
}

extension SexyJsonFloatType {
    public static func sexyTransform(_ value: Any?) -> Self? {
        switch value {
        case let str as String:
            return Self(str)
        case let num as NSNumber:
            return Self(num)
        default:
            return Self(0.0)
        }
    }
    
    public func sexyToValue() -> Any? {
        return self
    }
}

public protocol SexyJsonIntType:SexyJsonBasicType, BinaryInteger {
    init?(_ text: String, radix: Int)
    init(_ number: NSNumber)
}

extension SexyJsonIntType {
    public static func sexyTransform(_ value: Any?) -> Self? {
        switch value {
        case let str as String:
            return Self(str, radix: 10)
        case let num as NSNumber:
            return Self(num)
        default:
            return Self(0)
        }
    }
    
    public func sexyToValue() -> Any? {
        return self
    }
}

public protocol SexyJsonCGFloatType: SexyJsonBasicType {
    
}
extension SexyJsonCGFloatType {
    public static func sexyTransform(_ value: Any?) -> CGFloat? {
        switch value {
        case let str as String:
            return CGFloat((str as NSString).floatValue)
        case let num as NSNumber:
            return CGFloat(num.floatValue)
        default:
            return 0
        }
    }
    
    public func sexyToValue() -> Any? {
        return self
    }
    
}

extension CGFloat: SexyJsonCGFloatType {}
extension Bool: SexyJsonBoolType {}
extension Float: SexyJsonFloatType {}
extension Double: SexyJsonFloatType {}
extension Int: SexyJsonIntType {}
extension UInt: SexyJsonIntType {}
extension Int8: SexyJsonIntType {}
extension Int16: SexyJsonIntType {}
extension Int32: SexyJsonIntType {}
extension Int64: SexyJsonIntType {}
extension UInt8: SexyJsonIntType {}
extension UInt16: SexyJsonIntType {}
extension UInt32: SexyJsonIntType {}
extension UInt64: SexyJsonIntType {}

extension NSNumber: SexyJsonObjectType {
    public static func _sexyTransform(_ value: Any?) -> Any? {
        switch value {
        case let str as String:
            return NSNumber(value: (str as NSString).floatValue)
        case let num as NSNumber:
            return num
        default:
            return NSNumber(value: 0)
        }
    }
    
    public func sexyToValue() -> Any? {
        return self
    }
}

extension String: SexyJsonBasicType {
    public static func sexyTransform(_ value: Any?) -> String? {
        switch value {
        case let str as String:
            return str
        case let num as NSNumber:
            if NSStringFromClass(type(of: num)) == "__NSCFBoolean" {
                if num.boolValue {
                    return "true"
                }
                return "false"
            }
            return num.stringValue
        default:
            if let vl = value {
                switch vl {
                case nil, is NSNull:
                    return ""
                default:
                    return "\(vl)"
                }
            }
            return ""
        }
    }
    
    public func sexyToValue() -> Any? {
        return self
    }
}

extension NSString: SexyJsonObjectType {
    public static func _sexyTransform(_ value: Any?) -> Any? {
        if let str = String.sexyTransform(value) {
            return NSString(string: str)
        }
        return ""
    }
    
    public func sexyToValue() -> Any? {
        return self
    }
}

extension Array: SexyJsonCollectionType {
    public static func sexyTransform(_ value: Any?) -> [Element]? {
        guard let array = value as? NSArray else {
            print("SexyJson: Expect value not NSArray")
            return nil
        }
        typealias Element = Iterator.Element
        var result: [Element] = [Element]()
        array.forEach { (each) in
            if let element = (Element.self as? _SexyJsonBasicType.Type)?.sexyTransform(each) as? Element {
                result.append(element)
            }else if let element = (Element.self as? SexyJsonObjectType.Type)?._sexyTransform(each) as? Element {
                result.append(element)
            }else if let element = (Element.self as? SexyJson.Type)?.sexy_json(each) as? Element {
                result.append(element)
            }else if let element = each as? Element {
                result.append(element)
            }
        }
        return result
    }
    
    public func sexyToValue() -> Any? {
        var jsonArray = [Any]()
        self.forEach { (element) in
            if let value = (element as? _SexyJsonBase)?.sexyToValue() {
                jsonArray.append(value)
            }
        }
        return jsonArray
    }
}

extension Set: SexyJsonCollectionType {
    public static func sexyTransform(_ value: Any?) -> Set? {
        guard let array = value as? NSArray else {
            print("SexyJson: Expect value not NSArray")
            return nil
        }
        typealias Element = Iterator.Element
        var result = Set<Element>()
        array.forEach { (each) in
            if let element = (Element.self as? _SexyJsonBasicType.Type)?.sexyTransform(each) as? Element {
                result.insert(element)
            }else if let element = (Element.self as? SexyJsonObjectType.Type)?._sexyTransform(each) as? Element {
                result.insert(element)
            }else if let element = (Element.self as? SexyJson.Type)?.sexy_json(each) as? Element {
                result.insert(element)
            }else if let element = each as? Element {
                result.insert(element)
            }
        }
        return result
    }
    
    public func sexyToValue() -> Any? {
        var jsonArray = [Any]()
        self.forEach { (element) in
            if let value = (element as? _SexyJsonBase)?.sexyToValue() {
                jsonArray.append(value)
            }
        }
        return jsonArray
    }
}

extension Dictionary: SexyJsonCollectionType {
    public static func sexyTransform(_ value: Any?) -> Dictionary? {
        guard let nsDict = value as? NSDictionary else {
            print("SexyJson: Expect value not NSDictionary")
            return nil
        }
        var result: [Key: Value] = [Key: Value]()
        for (key, value) in nsDict {
            if let sKey = key as? Key, let nsValue = value as? NSObject {
                if let nValue = (Value.self as? _SexyJsonBasicType.Type)?.sexyTransform(nsValue) as? Value {
                    result[sKey] = nValue
                }else if let nValue = (Value.self as? SexyJsonObjectType.Type)?._sexyTransform(nsValue) as? Value {
                    result[sKey] = nValue
                }else if let nValue = (Value.self as? SexyJson.Type)?.sexy_json(nsValue) as? Value {
                    result[sKey] = nValue
                }else if let nValue = nsValue as? Value {
                    result[sKey] = nValue
                }
            }
        }
        return result
    }
    
    public func sexyToValue() -> Any? {
        var jsonMap = [String: Any]()
        self.forEach { (key,value) in
            if let val = (value as? _SexyJsonBase)?.sexyToValue() {
                jsonMap[key as! String] = val
            }
        }
        return jsonMap
    }
}

public extension RawRepresentable where Self: SexyJsonEnumType {
    public static func sexyTransform(_ value: Any?) -> Self? {
        if let transforType = RawValue.self as? SexyJsonBasicType.Type {
            if let typedValue = transforType.sexyTransform(value) {
                return Self(rawValue: typedValue as! RawValue)
            }
        }
        return nil
    }
    
    public func sexyToValue() -> Any? {
        return self.rawValue
    }
}

extension NSData: SexyJsonObjectType {
    public static func _sexyTransform(_ value: Any?) -> Any? {
        return Data.sexyTransform(value)
    }
    
    public func sexyToValue() -> Any? {
        return (self as Data).sexyToValue()
    }
}

extension Data: SexyJsonBasicType {
    public static func sexyTransform(_ value: Any?) -> Data? {
        switch value {
        case let num as NSNumber:
            return num.stringValue.data(using: .utf8)
        case let str as NSString:
            return str.data(using: String.Encoding.utf8.rawValue)
        case let data as NSData:
            return data as Data
        default:
            return nil
        }
    }
    
    public func sexyToValue() -> Any? {
        return String(data: self, encoding: .utf8)
    }
}

extension NSDate: SexyJsonObjectType {
    public static func _sexyTransform(_ value: Any?) -> Any? {
        return Date.sexyTransform(value)
    }
    
    public func sexyToValue() -> Any? {
        return (self as Date).sexyToValue()
    }
}

extension Date: SexyJsonBasicType {
    public static func sexyTransform(_ value: Any?) -> Date? {
        switch value {
        case let num as NSNumber:
            return Date(timeIntervalSince1970: num.doubleValue)
        case let str as NSString:
            return Date(timeIntervalSince1970: TimeInterval(atof(str as String)))
        default:
            return nil
        }
    }
    
    public func sexyToValue() -> Any? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter.string(from: self)
    }
}

extension NSURL: SexyJsonObjectType {
    public static func _sexyTransform(_ value: Any?) -> Any? {
        return URL.sexyTransform(value)
    }
    
    public func sexyToValue() -> Any? {
        return self.absoluteString
    }
}

extension URL: SexyJsonBasicType {
    public static func sexyTransform(_ value: Any?) -> URL? {
        switch value {
        case let str as NSString:
            return URL(string: str as String)
        default:
            return nil
        }
    }
    
    public func sexyToValue() -> Any? {
        return self.absoluteString
    }
}

extension SexyColor: SexyJsonObjectType {
    
    fileprivate func colorString() -> String {
        let comps = self.cgColor.components!
        let r = Int(comps[0] * 255)
        let g = Int(comps[1] * 255)
        let b = Int(comps[2] * 255)
        let a = Int(comps[3] * 255)
        var hexString: String = "#"
        hexString += String(format: "%02X%02X%02X", r, g, b)
        hexString += String(format: "%02X", a)
        return hexString
    }
    
    fileprivate static func getColor(hex: String) -> SexyColor? {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                // Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8
                return nil
            }
        } else {
            // "Scan hex error
            return nil
        }
        #if os(iOS) || os(tvOS) || os(watchOS)
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        #else
            return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
        #endif
    }
    
    public static func _sexyTransform(_ value: Any?) -> Any? {
        switch value {
        case let str as String:
            return getColor(hex: str)
        default:
            return nil
        }
    }
    
    public func sexyToValue() -> Any? {
        return colorString()
    }
}
