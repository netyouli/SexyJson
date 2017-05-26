//
//  ModelObject.swift
//  SexyJson
//
//  Created by WHC on 17/5/23.
//  Copyright © 2017年 WHC. All rights reserved.
//

import UIKit

enum WorkEnum: String,SexyJsonEnumType {
    case null = "nil"
    case one = "Work"
    case two = "Not Work"
}

enum IntEnum: Int,SexyJsonEnumType {
    case zero = 0
    case hao = 10
    case xxx = 20
}


struct Cls :SexyJson {

    
    var age: Int = 0
    var name: String!
    
    public mutating func sexyMap(_ map: [String : Any]) {
        
        age        <<<        map["age"]
        name       <<<        map["name"]
    }
    
}

struct SubArray :SexyJson {
    
    var test3: String!
    var test2: String!
    var cls: Cls!
    var test1: String!
    
    public mutating func sexyMap(_ map: [String : Any]) {
        
        test3        <<<        map["test3"]
        test2        <<<        map["test2"]
        cls          <<<        map["cls"]
        test1        <<<        map["test1"]
    }
    
}

struct NestArray :SexyJson {
    var test: String!
    
    public mutating func sexyMap(_ map: [String : Any]) {
        
        test        <<<        map["test"]
    }
    
}

class Sub :NSObject, SexyJson, NSCoding, NSCopying {
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.sexy_decode(decoder)
    }
    
    func encode(with aCoder: NSCoder) {
        self.sexy_encode(aCoder)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self.sexy_copy()
    }
    
    required override init() {}
    
    var test1: String!
    var test2: String!
    var test3: String!
    
    public func sexyMap(_ map: [String : Any]) {
        
        test1        <<<        map["test1"]
        test2        <<<        map["test2"]
        test3        <<<        map["test3"]
    }
    
}

struct ModelObject :SexyJson {
    
    var age: Int = 0
    var enmuStr: WorkEnum!
    var url: URL!
    var subArray: [SubArray]!
    var color: UIColor!
    var nestArray: [[NestArray]]?
    var enmuInt: IntEnum = .xxx
    var sub: Sub!
    var height: Int = 0
    var intArray: [Int]!
    var name: String!
    var learn: [String]!
    
    public mutating func sexyMap(_ map: [String : Any]) {
        
        age            <<<        map["age"]
        enmuStr        <<<        map["enmuStr"]
        url            <<<        map["url"]
        subArray       <<<        map["subArray"]
        color          <<<        map["color"]
        nestArray      <<<        map["nestArray"]
        
        enmuInt        <<<        map["enmuInt"]
        sub            <<<        map["sub"]
        height         <<<        map["height"]
        intArray       <<<        map["intArray"]
        name           <<<        map["name"]
        learn          <<<        map["learn"]
    }
    
}
