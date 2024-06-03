//
//  Object+Ext.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import Foundation
import RealmSwift

extension Object {
    static func fetchRequest<Item: Object>(_ predicate: NSPredicate, sortByKeyPath: String? = nil, ascending: Bool? = nil) -> Results<Item> {
        if let sortByKeyPath, let ascending {
            return Realm.shared().objects(Item.self).filter(predicate).sorted(byKeyPath: sortByKeyPath, ascending: ascending)
        } else {
            return Realm.shared().objects(Item.self).filter(predicate)
        }
    }
}
