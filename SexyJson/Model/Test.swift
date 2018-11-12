//
//  Test.swift
//  SexyJson
//
//  Created by WHC on 2018/4/10.
//  Copyright © 2018年 WHC. All rights reserved.
//

import Foundation



/**
 * Copyright 2018 wuhaichao.com
 * Auto-generated:2018/4/10 下午3:20:26
 *
 * @author wuhaichao.com (whc)
 * @website http://wuhaichao.com
 * @github https://github.com/netyouli
 */


//MARK: - hotelListFilterItem -

struct HotelListFilterItem:SexyJson {
    
    var  hotelStyle: String?
    mutating func sexyMap(_ map: [String : Any]) {
        hotelStyle    <<< map["hotelStyle"]
    }
    
}

//MARK: - dataList -

struct DataList:SexyJson {
    var name: String?
    var isDefault: Bool = false
    var hotelListFilterItem: HotelListFilterItem?
    var dataId: Int = 0
    var tagList: [Any]?
    
    public mutating func sexyMap(_ map: [String : Any]) {
        
        name                   <<<    map["name"]
        isDefault              <<<    map["isDefault"]
        hotelListFilterItem    <<<    map["hotelListFilterItem"]
        dataId                 <<<    map["dataId"]
        tagList                <<<    map["tagList"]
        
        
    }
}

//MARK: - queryHotelObj -

struct QueryHotelObj:SexyJson {
    var dataList: [DataList]?
    
    public mutating func sexyMap(_ map: [String : Any]) {
        
        dataList    <<<    map["dataList"]
        
        
    }
}

//MARK: - BaseClass -

struct BaseClass:SexyJson {
    var queryHotelObj: QueryHotelObj?
    var resultType: Int = 0
    var message: String?
    
    public mutating func sexyMap(_ map: [String : Any]) {
        
        queryHotelObj    <<<    map["queryHotelObj"]
        resultType       <<<    map["resultType"]
        message          <<<    map["message"]
        
        
    }
}











