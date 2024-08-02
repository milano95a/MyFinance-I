//
//  RealmSwiftObject+Ext.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 02/08/24.
//

import SwiftUI
import RealmSwift
import Realm

extension RealmSwiftObject {
    func addToDB() {
        Realm.writeWithTry { realm in
            realm.add(self)
        }
    }
    
    func deleteFromDB() {
        self.writeToDB { thawedObj, thawedRealm in
            thawedRealm.delete(thawedObj)
        }
    }
    
    func writeToDB(_ callback: (RealmSwiftObject, Realm) -> Void) {
        guard let thawedObj = self.thaw() else { return }
        assert(thawedObj.isFrozen == false)
        guard let thawedRealm = thawedObj.realm else { return }
        do {
            try thawedRealm.write {
                callback(thawedObj, thawedRealm)
            }
        } catch let error {
            print(error)
        }
    }
}

extension ObjectId {
    func findById<T: RealmSwiftObject>() -> T? {
        Realm.shared().object(ofType: T.self, forPrimaryKey: self)
    }
}

extension Realm {
    // TODO: use this shared instance everywhere
    static func shared() -> Realm {
        let configuration = Realm.Configuration(schemaVersion: 7)
        Realm.Configuration.defaultConfiguration = configuration
        let realm = try! Realm()
        return realm
    }
    
    static func writeWithTry(_ callback: (Realm) -> Void ) {
        do {
            let realm = try Realm()
            try realm.write {
                callback(realm)
            }
        } catch let error {
            print(error)
        }
    }
    
    static func deleteWithTry(_ object: Object) {
        Realm.writeWithTry { realm in
            realm.delete(object)
        }
    }
    
    static func addWithTry(_ object: Object) {
        Realm.writeWithTry { realm in
            realm.add(object)
        }
    }
    
    static func deleteAll() {
        Realm.writeWithTry { realm in
            realm.deleteAll()
        }
    }
    
    static func fetchRequest<Element: RealmFetchable>(_ predicate: NSPredicate) -> Results<Element> {
        return Realm.shared().objects(Element.self)
    }
}
