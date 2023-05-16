//
//  SavingsManager.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 12/05/23.
//

import Foundation
import RealmSwift

class SavingsManager: ObservableObject {
    @Published var items = Realm.shared.objects(Saving.self)
    
    // MARK: Intent(s)
    
    func create(_ date: Date, _ amount: Int) {
        let saving = Saving(date: date, amount: amount, change: 0)
        saving.addToDB()
    }
    
    func delete(_ saving: Saving) {
        saving.deleteFromDB()
    }
    
    func update(_ saving: Saving, _ date: Date, _ amount: Int) {
        saving.writeToDB { thawedObj, thawedRealm in
            if let saving = thawedObj as? Saving {
                saving.date = date
                saving.amount = amount
            }
        }
    }
}

class Saving: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date = Date()
    @Persisted var amount: Int = 0
    @Persisted var change: Double = 0
    
    init(date: Date, amount: Int, change: Double) {
        self.date = date
        self.amount = amount
        self.change = change
    }
    
    override init() { }
}
