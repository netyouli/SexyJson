# SexyJson

![Build Status](https://api.travis-ci.org/netyouli/SexyJson.svg?branch=master)
[![Pod Version](http://img.shields.io/cocoapods/v/SexyJson.svg?style=flat)](http://cocoadocs.org/docsets/SexyJson/)
[![Platform](https://img.shields.io/cocoapods/p/SnapKit.svg?style=flat)](https://github.com/netyouli/)
[![Pod License](http://img.shields.io/cocoapods/l/SexyJson.svg?style=flat)](https://opensource.org/licenses/MIT)

SexyJson is Swift4 json parse open source library quickly and easily, perfect supporting class and struct model, support the KVC model, fully oriented protocol architecture, support iOS and MAC OS X

**Objective-c version** 👉 [WHC_Model](https://github.com/netyouli/WHC_Model)

bug修复：修复枚举类型转换失败

Note
==============
- The definition of model must implement SexyJson protocol
- If you have any enumeration type must be specified in the definition of model data type and implementation SexyJsonEnumType protocol
- If you want to use **swift3.2**, please pod SexyJson '~> 0.0.4'

Require
==============
* iOS 8.0+ / Mac OS X 10.11+ / tvOS 9.0+
* Xcode 8.0 or later
* Swift 4.0

Install
==============
* CocoaPods: pod 'SexyJson'

Model
==============
This is an example of json:
```swift
let json = "{\"age\":25,\"enmuStr\":\"Work\",\"url\":\"https:\\/\\/www.baidu.com\",
            \"subArray\":[{\"test3\":\"test3\",\"test2\":\"test2\",\"cls\":{\"age\":10,
            \"name\":\"swift\"},\"test1\":\"test1\"},{\"test3\":\"test3\",\"test2\":\"test2\",
            \"cls\":{\"age\":10,\"name\":\"swift\"},\"test1\":\"test1\"}],\"color\":\"0xffbbaa\",
            \"nestArray\":[[{\"test\":\"test1\"},{\"test\":\"test2\"}],[{\"test\":\"test3\"},
            {\"test\":\"test4\"}]],\"enmuInt\":10,\"sub\":{\"test1\":\"test1\",\"test2\":\"test2\",
            \"test3\":\"test3\"},\"height\":175,\"intArray\":[1,2,3,4],\"name\":\"吴海超\",
            \"learn\":[\"iOS\",\"android\",\"js\",\"nodejs\",\"python\"]}"
```
The model class:
```swift
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

struct Model :SexyJson {

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

    /// Model mapping
    public mutating func sexyMap(_ map: [String : Any]) {
        age      <<<   map["age"]
        enmuStr  <<<   map["enmuStr"]
        url      <<<   map["url"]
        subArray <<<   map["subArray"]
        color    <<<   map["color"]
        nestArray <<<  map["nestArray"]
        enmuInt   <<<  map["enmuInt"]
        sub       <<<  map["sub"]
        height    <<<  map["height"]
        intArray  <<<  map["intArray"]
        name      <<<  map["name"]
        learn     <<<  map["learn"]
    }
}

```
**You don't need to manually create the SexyJson model class you can use open source tools with the help of** [WHC_DataModel.app](https://github.com/netyouli/WHC_DataModelFactory) **automatically created SexyJson model**

Usage
==============

Json is converted into a model object(json -> model)
```swift
let model = Model.sexy_json(json)
```

Model object converted into the dictionary(model -> dictionary)
```swift
let dictionary = model.sexy_dictionary()
```

Model object converted into the json string(model -> json)
```swift
let jsonStr = model.sexy_json()
```

SexyJson support json parse the key path
```swift
let subArrayModel = SubArray.sexy_json(json, keyPath: "subArray[0]")
let subNestArray = NestArray.sexy_json(json, keyPath: "nestArray[0][0]")
let test = String.sexy_json(json, keyPath: "nestArray[0][0].test")
```

Json is converted into a model array object(json -> [model])
```swift
let arrayModel = [Model].sexy_json(json)
```

Model object array converted into the array([model] -> array)
```swift
let array = arrayModel.sexy_array()
```

Model object array converted into the json string([model] -> json)
```swift
let arrayJson = arrayModel.sexy_json()
```
SexyJson support model kvc( Model class implement Codable protocol )
```swift
let sub = Sub.sexy_json(json, keyPath: "sub")
if let modelCodingData = try? JSONEncoder().encode(modelCoding) {
    if let modelUncoding = try? JSONDecoder().decode(Sub.self, from: modelCodingData) {
        print("modelUncodingJson = \(modelUncoding.sexy_json()!)")
    }
}
```
Prompt
==============
If you want to view the analytical results, please download this demo to check the specific usage

Licenses
==============
All source code is licensed under the MIT License.

