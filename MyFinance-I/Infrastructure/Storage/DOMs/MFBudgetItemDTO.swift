//
//  MFBudgetItemDTO.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 11/07/24.
//

import Foundation
import RealmSwift

class MFBudgetItemDTO: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var amount: Int = 0
    
    func update(_ name: String?, _ amount: Int?) {
        self.writeToDB { thawedObj, thawedRealm in
            if let item = thawedObj as? MFBudgetItemDTO {
                if let name {
                    item.name = name
                }
                if let amount {
                    item.amount = amount
                }
            }
        }
    }
}
