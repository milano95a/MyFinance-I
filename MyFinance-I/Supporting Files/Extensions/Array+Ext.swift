//
//  Array+Ext.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 02/08/24.
//

import SwiftUI
import RealmSwift
import Realm

extension Array where Element: RealmSwiftObject {
    func addToDB() {
        Realm.writeWithTry { realm in
            realm.add(self)
        }
    }
}
