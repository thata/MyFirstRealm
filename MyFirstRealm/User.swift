//
//  User.swift
//  MyFirstRealm
//
//  Created by Takashi Hatakeyama on 2016/04/05.
//  Copyright © 2016年 esm. All rights reserved.
//

import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var age = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
