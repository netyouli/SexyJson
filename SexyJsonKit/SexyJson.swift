//
//  SexyJson.swift
//  SexyJson
//
//  Created by WHC on 17/5/5.
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

import Foundation

fileprivate extension _SexyJsonBase {
    //// parser json keypath value
    fileprivate static func _sexyKeyPathValue(_ keyPathArray: [String], json: Any?) -> Any? {
        var jsonObject = json
        keyPathArray.forEach({ (key) in
            if let range = key.range(of: "[") {
                let realKey = String(key[..<range.lowerBound])
                var indexString = key
                if !realKey.isEmpty {
                    jsonObject = (jsonObject as! Dictionary<String, Any>)[realKey]
                    indexString = String(key[range.lowerBound...])
                }
                var handleIndexString = indexString.replacingOccurrences(of: "]", with: ",")
                handleIndexString = handleIndexString.replacingOccurrences(of: "[", with: "")
                if handleIndexString.hasSuffix(",") {
                    handleIndexString = String(handleIndexString[..<handleIndexString.index(handleIndexString.endIndex, offsetBy: -1)])
                }
                if !handleIndexString.isEmpty {
                    handleIndexString.components(separatedBy: ",").forEach({ (i) in
                        if let index = Int(i) {
                            if let jsonArray = (jsonObject as? [Any])?[index] {
                                jsonObject = jsonArray
                            }else {
                                print("SexyJson: keyPath 值异常")
                                jsonObject = nil
                            }
                        }else {
                            print("SexyJson: keyPath 数组下标 值异常")
                            jsonObject = nil
                        }
                    })
                }else {
                    print("SexyJson: keyPath 数组下标 值异常")
                    jsonObject = nil
                }
            }else {
                jsonObject = (jsonObject as! Dictionary<String, Any>)[key]
            }
        })
        return jsonObject
    }
    
    /// parser json
    fileprivate static func _sexyJson(_ json: Any?, keyPath: String?) -> Self? {
        if json != nil {
            if keyPath != nil && keyPath != "" {
                var json_object: Any!
                switch json {
                case let str as String:
                    let json_data = str.data(using: .utf8)
                    return self._sexyJson(json_data, keyPath: keyPath)
                case let data as Data:
                    json_object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    return self._sexyJson(json_object, keyPath: keyPath)
                case _ as Dictionary<String, Any> , _ as Array<Any>:
                    if let keyPathArray = keyPath?.components(separatedBy: ".") {
                        let jsonObject = _sexyKeyPathValue(keyPathArray, json: json)
                        switch jsonObject {
                        case _ as Dictionary<String, Any>:
                            print("SexyJson: Call api error,array json use api \(self).json(json)")
                            return nil
                        case _ as Array<Any>:
                            print("SexyJson: Call api error,array json use api [\(self)].json(json)")
                            return nil
                        default:
                            if let value  = jsonObject as? Self {
                                return value
                            }
                            print("SexyJson: Call api error, json not nil")
                            return nil
                        }
                    }
                default:
                    print("SexyJson: Call api error, json not nil")
                    return nil
                }
            }
            if let value  = json as? Self {
                return value
            }
            return nil
        }
        return nil
    }
}

public extension SexyJsonBasicType {
    
    /// 解析json
    ///
    /// - Parameters:
    ///   - json: json数据(字符串、字典，data)
    ///   - keyPath: json key路径
    /// - Returns: model对象
    public static func sexy_json(_ json: Any?, keyPath: String?) -> Self? {
        return _sexyJson(json, keyPath: keyPath)
    }
}

public extension SexyJsonObjectType {
    
    /// 解析json
    ///
    /// - Parameters:
    ///   - json: json数据(字符串、字典，data)
    ///   - keyPath: json key路径
    /// - Returns: model对象
    public static func sexy_json(_ json: Any?, keyPath: String?) -> Self? {
        return _sexyJson(json, keyPath: keyPath)
    }
}

public extension SexyJson {
    
    //MARK: - json -> model  -
    
    
    /// 解析json
    ///
    /// - Parameter json: json数据(字符串、字典，data)
    /// - Returns: model对象
    public static func sexy_json(_ json: Any?) -> Self? {
        switch json {
        case let str as String:
            let json_data = str.data(using: .utf8)
            return Self.sexy_json(json_data)
        case let data as Data:
            let json_object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return Self.sexy_json(json_object)
        case let dictionary as Dictionary<String, Any>:
            var model = Self.init()
            model.sexyMap(dictionary)
            return model
        case _ as Array<Any>:
            print("SexyJson: Call api error,array json use api [\(self)].json(json)")
            return nil
        default:
            print("SexyJson: Call api error, json not nil")
            return nil
        }
    }
    
    /// 解析json
    ///
    /// - Parameters:
    ///   - json: json数据(字符串、字典，data)
    ///   - keyPath: json key路径
    /// - Returns: model对象
    public static func sexy_json(_ json: Any?, keyPath: String?) -> Self? {
        if json != nil {
            if keyPath != nil && keyPath != "" {
                var json_object: Any!
                switch json {
                case let str as String:
                    let json_data = str.data(using: .utf8)
                    return self.sexy_json(json_data, keyPath: keyPath)
                case let data as Data:
                    json_object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    return self.sexy_json(json_object, keyPath: keyPath)
                case _ as Dictionary<String, Any> , _ as Array<Any>:
                    if let keyPathArray = keyPath?.components(separatedBy: ".") {
                        let jsonObject = _sexyKeyPathValue(keyPathArray, json: json)
                        switch jsonObject {
                        case _ as Dictionary<String, Any>:
                            return self.sexy_json(jsonObject)
                        case _ as Array<Any>:
                            print("SexyJson: Call api error,array json use api [\(self)].json(json)")
                            return nil
                        default:
                            print("SexyJson: Call api error, json not nil")
                            return nil
                        }
                    }
                default:
                    print("SexyJson: Call api error, json not nil")
                    return nil
                }
            }
            return self.sexy_json(json)
        }
        return nil
    }
    
    //MARK: - model -> json -
    
    
    /// model->json string
    ///
    /// - Returns: json string
    public func sexy_json() -> String? {
        if let map = self.sexy_dictionary() {
            if JSONSerialization.isValidJSONObject(map) {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: map, options: [])
                    return String(data: jsonData, encoding: .utf8)
                }catch let error {
                    print("SexyJson: error \(error)")
                }
            }else {
                print("SexyJson: error invalid json map")
            }
            return nil
        }
        return nil
    }
    
    /// model->json 字典
    ///
    /// - Returns: json 字典
    public func sexy_dictionary() -> [String: Any]? {
        return self.sexyToValue() as? [String : Any]
    }
}


public extension NSObject {
    private struct SexyJsonConst {
        static var cachePropertyList = "SexyJsonConst###cachePropertyList"
    }
    
    private class func getPropertyList() -> [String] {
        if let cachePropertyList = objc_getAssociatedObject(self, &SexyJsonConst.cachePropertyList) {
            return cachePropertyList as! [String]
        }
        var propertyList = [String]()
        if let superClass = class_getSuperclass(self.classForCoder()) {
            if superClass != NSObject.classForCoder() {
                if let superList = (superClass as? NSObject.Type)?.getPropertyList() {
                    propertyList.append(contentsOf: superList)
                }
            }
        }
        var count:UInt32 =  0
        if let properties = class_copyPropertyList(self.classForCoder(), &count) {
            for i in 0 ..< count {
                let name = property_getName(properties[Int(i)])
                if let nameStr = String(cString: name, encoding: .utf8) {
                    propertyList.append(nameStr)
                }
            }
        }
        objc_setAssociatedObject(self, &SexyJsonConst.cachePropertyList, propertyList, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return propertyList
    }
    
    //MARK: - model -> coding -
    
    
    /// model kvc编码
    ///
    /// - Parameter aCoder: 编码对象
    public func sexy_encode(_ aCoder: NSCoder) {
        let selfType = type(of: self)
        selfType.getPropertyList().forEach { (name) in
            if let value = self.value(forKey: name) {
                aCoder.encode(value, forKey: name)
            }
        }
    }
    
    
    /// model kvc解码
    ///
    /// - Parameter decode: 解码对象
    public func sexy_decode(_ decode: NSCoder) {
        let selfType = type(of: self)
        selfType.getPropertyList().forEach { (name) in
            if let value = decode.decodeObject(forKey: name) {
                self.setValue(value, forKey: name)
            }
        }
    }
    
    //MARK: - model -> copying -
    
    
    /// model copy
    ///
    /// - Returns: copy model 对象
    public func sexy_copy() -> Self {
        let selfType = type(of: self)
        let copyModel = selfType.init()
        selfType.getPropertyList().forEach { (name) in
            if let value = self.value(forKey: name) {
                let valueType = type(of: value)
                switch valueType {
                case is _SexyJsonBasicType.Type:
                    copyModel.setValue(value, forKey: name)
                default:
                    if let copyValue = (value as? NSObject)?.copy() {
                        copyModel.setValue(copyValue, forKey: name)
                    }
                }
            }
        }
        return copyModel
    }
}

public extension Dictionary {
    
    /// map->json string
    ///
    /// - Returns: json string
    public func sexy_json() -> String? {
        if let jsonMap = self.sexyToValue() {
            if JSONSerialization.isValidJSONObject(jsonMap) {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonMap, options: [])
                    return String(data: jsonData, encoding: .utf8)
                }catch let error {
                    print("SexyJson: error \(error)")
                }
            }else {
                print("SexyJson: error invalid json map")
            }
            return nil
        }
        return nil
    }
}

public extension Array {
    
    //MARK: - json -> model  -
    
    
    /// 解析json->[Model]
    ///
    /// - Parameter json: json数据(字符串、字典，data)
    /// - Returns: 模型数组[Model]
    public static func sexy_json(_ json: Any?) -> [Element]? {
        switch json {
        case let jsonList as [Any]:
            var modelList = [Element]()
            jsonList.forEach({ (each) in
                switch Element.self {
                case is SexyJson.Type:
                    if let model = (Element.self as? SexyJson.Type)?.sexy_json(each) {
                        if let value = model as? Element {
                            modelList.append(value)
                        }
                    }
                case is _SexyJsonBasicType.Type:
                    if let model = (Element.self as? _SexyJsonBasicType.Type)?.sexyTransform(each) {
                        if let value = model as? Element {
                            modelList.append(value)
                        }
                    }
                case is SexyJsonObjectType.Type:
                    if let model = (Element.self as? SexyJsonObjectType.Type)?._sexyTransform(each) {
                        if let value = model as? Element {
                            modelList.append(value)
                        }
                    }
                default:
                    if let value = each as? Element {
                        modelList.append(value)
                    }
                }
            })
            return modelList
        case let str as String:
            let json_data = str.data(using: .utf8)
            return [Element].sexy_json(json_data)
        case let data as Data:
            let json_object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return [Element].sexy_json(json_object)
        case _ as Dictionary<String, Any>:
            print("Call api error,object json use api Model.json(json)")
            return nil
        default:
            print("Call api error, json not nil")
            return nil
        }
    }
    
    
    /// 解析json->[Model]
    ///
    /// - Parameters:
    ///   - json: json数据(字符串、字典，data)
    ///   - keyPath: json keyPath路径
    /// - Returns: 模型数组[Model]
    public static func sexy_json(_ json: Any?, keyPath: String?) -> [Element]? {
        if json != nil {
            if keyPath != nil && keyPath != "" {
                var json_object: Any!
                switch json {
                case let str as String:
                    let json_data = str.data(using: .utf8)
                    return self.sexy_json(json_data, keyPath: keyPath)
                case let data as Data:
                    json_object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    return self.sexy_json(json_object, keyPath: keyPath)
                case _ as Dictionary<String, Any>,  _ as Array<Any>:
                    if let keyPathArray = keyPath?.components(separatedBy: ".") {
                        let jsonObject = _sexyKeyPathValue(keyPathArray, json: json)
                        switch jsonObject {
                        case _ as Dictionary<String, Any>:
                            print("Call api error,object json use api Model.json(json)")
                            return nil
                        case _ as [Any]:
                            return [Element].sexy_json(jsonObject)
                        default:
                            print("Call api error, json not nil")
                            return nil
                        }
                    }
                default:
                    print("Call api error, json not nil")
                    return nil
                }
            }
            return [Element].sexy_json(json)
        }
        return nil
    }
    
    //MARK: - model -> json -
    
    
    /// [Model]数组-> json string
    ///
    /// - Parameter format: 格式化json
    /// - Returns: json string
    public func sexy_json(format: Bool = false) -> String? {
        if let map = self.sexy_array() {
            if JSONSerialization.isValidJSONObject(map) {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: map, options: format ? .prettyPrinted : [])
                    return String(data: jsonData, encoding: .utf8)
                }catch let error {
                    print("SexyJson: error \(error)")
                }
            }else {
                print("SexyJson: error invalid json map")
            }
            return nil
        }
        return nil
    }
    
    /// [Model]数组-> [json]
    ///
    /// - Returns: [json]
    public func sexy_array() -> [Any]? {
        return self.sexyToValue() as? [Any]
    }
}
