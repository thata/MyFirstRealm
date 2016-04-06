//
//  RealmStore.swift
//  MyFirstRealm
//
//  Created by Takashi Hatakeyama on 2016/04/06.
//  Copyright © 2016年 esm. All rights reserved.
//

import RealmSwift

class RealmStore {
    static let sharedInstance = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyFirstRealm"))
}
