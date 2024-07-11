//
//  ImportManager.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 18/05/23.
//

import Foundation
import RealmSwift

class ImportManager: ObservableObject {
    
    func importData(_ data: ExportData) {
        Realm.deleteAll()
        Realm.writeWithTry { realm in
            for expense in data.expenses {
                realm.add(expense)
            }
            
            for debt in data.debts {
                realm.add(debt)
            }
            
            for credit in data.credits {
                realm.add(credit)
            }
            
            for saving in data.savings {
                realm.add(saving)
            }
        }
    }
}
