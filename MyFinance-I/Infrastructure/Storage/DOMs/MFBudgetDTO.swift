//
//  MFBudgetDTO.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 11/07/24.
//

import Foundation
import RealmSwift

class MFBudgetDTO: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = Date()
    @Persisted var amount: Int = 0
    @Persisted var budgetItem: RealmSwift.List<MFBudgetItemDTO>
    
    func update(_ amount: Int, _ date: Date) {
        self.writeToDB { thawedObj, thawedRealm in
            if let item = thawedObj as? MFBudgetDTO {
                item.amount = amount
                item.date = date
            }
        }
    }
    
    func append(_ child: MFBudgetItemDTO) {
        self.writeToDB { thawedObj, thawedRealm in
            if let item = thawedObj as? MFBudgetDTO {
                item.budgetItem.append(child)
            }
        }
    }
}
