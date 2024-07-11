//
//  SavingsManager.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 12/05/23.
//

import Foundation
import RealmSwift

class SavingsManager: ObservableObject {
    @Published var items = Realm.shared().objects(Saving.self).sorted(byKeyPath: "date", ascending: false)
    
    // MARK: Intent(s)
    
    func create(_ date: Date, _ amount: Int) {
        self.objectWillChange.send()
        let saving = Saving(date: date, amount: amount, change: 0)
        saving.addToDB()
    }
    
    func delete(_ saving: Saving) {
        self.objectWillChange.send()
        saving.deleteFromDB()
    }
    
    func update(_ saving: Saving, _ date: Date, _ amount: Double) {
        self.objectWillChange.send()
        saving.writeToDB { thawedObj, thawedRealm in
            if let saving = thawedObj as? Saving {
                saving.date = date
                saving.amountWithFraction = amount
            }
        }
    }
    
    func change(for item: Saving) -> Double {
        var result = 0.0
        
        if items.count < 2 { return result }
        
        for index in stride(from: items.count-2, through: 0, by: -1) {
            if item.id == items[index].id {
                let currentAmount = items[index].amountWithFraction
                let previousAmount = items[index+1].amountWithFraction
                let change = currentAmount / previousAmount
                if change > 1 {
                    result = (change-1)  * 100
                    return result.rounded(toPlaces: 2)
                } else {
                    result = (1 - change) * -100
                    return result.rounded(toPlaces: 2)
                }
            }
        }
        return result.rounded(toPlaces: 2)
    }
}
