//
//  User.swift
//  MyFirstRealm
//
//  Created by Takashi Hatakeyama on 2016/04/05.
//  Copyright © 2016年 esm. All rights reserved.
//

import RealmSwift
import ObjectMapper

class User: Object, Mappable {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var age = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: Map){
        self.init()
    }
    
    func mapping(map: Map)
    {
        age <- map["age"]
        id <- map["id"]
        name <- map["name"]
    }
}
