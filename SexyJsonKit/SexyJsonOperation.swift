//
//  SexyJsonOperation.swift
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

import Foundation

infix operator <<<

//MARK: - SexyJsonBasicType -
public func <<< <T: _SexyJsonBasicType>(left: inout T!, right: Any?) -> Void {
    left = T.sexyTransform(right)
}

public func <<< <T: _SexyJsonBasicType>(left: inout T?, right: Any?) -> Void {
    left = T.sexyTransform(right)
}

public func <<< <T: _SexyJsonBasicType>(left: inout T, right: Any?) -> Void {
    if let value = T.sexyTransform(right) {
        left = value
    }
}

//MARK: - SexyJsonEnumType -
public func <<< <T: SexyJsonEnumType> (left: inout T!, right: Any?) -> Void {
    left = T.sexyTransform(right)
}

public func <<< <T: SexyJsonEnumType>(left: inout T?, right: Any?) -> Void {
    left = T.sexyTransform(right)
}

public func <<< <T: SexyJsonEnumType>(left: inout T, right: Any?) -> Void {
    if let value = T.sexyTransform(right) {
        left = value
    }
}

//MARK: - SexyJsonObjectType -

public func <<< <T: SexyJsonObjectType>(left: inout T!, right: Any?) -> Void {
    left = T._sexyTransform(right) as? T
}

public func <<< <T: SexyJsonObjectType>(left: inout T?, right: Any?) -> Void {
    left = T._sexyTransform(right) as? T
}

public func <<< <T: SexyJsonObjectType>(left: inout T, right: Any?) -> Void {
    if let value = T._sexyTransform(right) as? T {
        left = value
    }
}


//MARK: - SexyJson -

public func <<< <T: SexyJson>(left: inout T?, right: Any?) -> Void {
    if let rightMap = right as? [String: Any] {
        left = T.init()
        left!.sexyMap(rightMap)
    }
}

public func <<< <T: SexyJson>(left: inout T!, right: Any?) -> Void {
    if let rightMap = right as? [String: Any] {
        left = T.init()
        left.sexyMap(rightMap)
    }
}

public func <<< <T: SexyJson>(left: inout T, right: Any?) -> Void {
    if let rightMap = right as? [String: Any] {
        left.sexyMap(rightMap)
    }
}

//MARK: - [SexyJsonBasicType] -
public func <<< <T: _SexyJsonBasicType>(left: inout [T]?, right: Any?) -> Void {
    if right != nil {
        left = [T].init()
        left! <<< right
    }
}

public func <<< <T: _SexyJsonBasicType>(left: inout [T]!, right: Any?) -> Void {
    if right != nil {
        left = [T].init()
        left! <<< right
    }
}

public func <<< <T: _SexyJsonBasicType>(left: inout [T], right: Any?) -> Void {
    if let rightMap = right as? [Any] {
        rightMap.forEach({ (map) in
            left.append(T.sexyTransform(map)!)
        })
    }
}

//MARK: - [SexyJsonEnumType] -
public func <<< <T: SexyJsonEnumType> (left: inout [T]!, right: Any?) -> Void {
    if right != nil {
        left = [T].init()
        left! <<< right
    }
}

public func <<< <T: SexyJsonEnumType>(left: inout [T]?, right: Any?) -> Void {
    if right != nil {
        left = [T].init()
        left! <<< right
    }
}

public func <<< <T: SexyJsonEnumType>(left: inout [T], right: Any?) -> Void {
    if let rightMap = right as? [Any] {
        rightMap.forEach({ (map) in
            left.append(T.sexyTransform(map)!)
        })
    }
}

//MARK: - [SexyJsonObjectType] -

public func <<< <T: SexyJsonObjectType>(left: inout [T]!, right: Any?) -> Void {
    if right != nil {
        left = [T].init()
        left! <<< right
    }
}

public func <<< <T: SexyJsonObjectType>(left: inout [T]?, right: Any?) -> Void {
    if right != nil {
        left = [T].init()
        left! <<< right
    }
}

public func <<< <T: SexyJsonObjectType>(left: inout [T], right: Any?) -> Void {
    if let rightMap = right as? [Any] {
        rightMap.forEach({ (map) in
            if let value = T._sexyTransform(map) as? T {
                left.append(value)
            }
        })
    }
}

//MARK: - [SexyJson] -

public func <<< <T: SexyJson>(left: inout [T]?, right: Any?) -> Void {
    if right != nil {
        left = [T].init()
        left! <<< right
    }
}

public func <<< <T: SexyJson>(left: inout [T]!, right: Any?) -> Void {
    if right != nil {
        left = [T].init()
        left! <<< right
    }
}

public func <<< <T: SexyJson>(left: inout [T], right: Any?) -> Void {
    if let rightMap = right as? [Any] {
        rightMap.forEach({ (map) in
            if let elementMap = map as? [String : Any] {
                var element = T.init()
                element.sexyMap(elementMap)
                left.append(element)
            }
        })
    }
}

