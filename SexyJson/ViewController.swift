//
//  ViewController.swift
//  SexyJson
//
//  Created by WHC on 17/5/5.
//  Copyright © 2017年 WHC. All rights reserved.
//
//  Github <https://github.com/netyouli/SexyJson>

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var sexyLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// layout 
        sexyLab.frame = UIScreen.main.bounds
        
        let json = """
{
    "queryHotelObj": {
        "dataList": [
            {
                "name": "酒店",
                "isDefault": true,
                "hotelListFilterItem": {},
                "dataId": 1,
                "tagList": []
            },
            {
                "name": "公寓",
                "isDefault": true,
                "hotelListFilterItem": {
                    "hotelStyle": "80,81"
                },
                "dataId": 8,
                "tagList": [
                    {
                        "type": 0,
                        "name": "测试1",
                        "targetUrl": "aaa"
                    }
                ]
            },
            {
                "name": "时租",
                "isDefault": true,
                "hotelListFilterItem": {},
                "dataId": 3,
                "tagList": []
            },
            {
                "name": "国际",
                "isDefault": true,
                "hotelListFilterItem": {},
                "dataId": 9,
                "tagList": []
            },
            {
                "name": "精选",
                "isDefault": true,
                "hotelListFilterItem": {
                    "hotelStyle": "8"
                },
                "dataId": 7,
                "tagList": []
            }
        ]
    },
    "resultType": 0,
    "message": ""
}
"""
        
        let test = BaseClass.sexy_json(json)
    
        let obj = OBject()
        obj.ks = "09"
        
        let jk = obj.sexy_copy()
        
        if let testjson = test?.sexy_json(format: true) {
            print("testJson = " + testjson)
        }
        
        let jsonString = try! String(contentsOfFile: Bundle.main.path(forResource: "ModelObject", ofType: "json")!, encoding: .utf8)
        let jsonData = jsonString.data(using: .utf8)
        
        print("***************** Model *****************\n\n")
        print("json -> model 对象:")
        let model = ModelObject.sexy_json(jsonData)
        print("model = \(String(describing: model))")
        print("\n---------------------------------------------------\n")
        
        print("model 对象 -> 字典:")
        let modelDict = model?.sexy_dictionary()
        print("modelDict = \(modelDict!)")
        print("\n---------------------------------------------------\n")
        
        print("model 对象 -> json字符串:")
        let modelJson = model?.sexy_json()
        print("modelJson = \(modelJson!)")
        
        
        
        print("\n***************** [Model] *****************\n\n")
        print("json -> [Model] 对象:")
        let arrayModel = [SubArray].sexy_json(modelJson,keyPath: "subArray")
        print("arrayModel = \(arrayModel!)")
        print("\n---------------------------------------------------\n")
        /* keyPath 用法展示
        let subArrayModel = SubArray.sexy_json(modelJson,keyPath: "subArray[0]")
        let subNestArray = NestArray.sexy_json(modelJson,keyPath: "nestArray[0][0]")
        let test = String.sexy_json(modelJson, keyPath: "nestArray[0][0].test")
        */
        
        print("[model] 对象 -> 数组:")
        let arrayModelArray = arrayModel?.sexy_array()
        print("arrayModelArray = \(arrayModelArray!)")
        print("\n---------------------------------------------------\n")
        
        print("[model] 对象 -> json字符串:")
        let arrayModelJson = arrayModel?.sexy_json(format: true)
        print("arrayModelJson = \(arrayModelJson!)")
        
        
        print("\n***************** Model Coding *****************\n\n")
        let modelCoding = Sub.sexy_json(jsonData, keyPath: "sub")
        if let modelCodingData = try? JSONEncoder().encode(modelCoding) {
            if let modelUncoding = try? JSONDecoder().decode(Sub.self, from: modelCodingData) {
                print("modelUncodingJson = \(modelUncoding.sexy_json()!)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayout()
    }

    private func setLayout() {
        sexyLab.numberOfLines = 0
        sexyLab.textAlignment = .center
        sexyLab.font = UIFont.boldSystemFont(ofSize: 30)
        sexyLab.text = "SexyJson\nFast"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

