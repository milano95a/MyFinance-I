//
//  BudgetBrain.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import Foundation
import RealmSwift

class MFBudgetsListViewModel: ObservableObject {
    @Published var items: Results<MFBudgetDTO>
    
    init() {
        items = MFBudgetDTO.fetchRequest(.all).sorted(by: \.date, ascending: false)
    }
    
    func save(_ item: MFBudgetDTO) {
        self.objectWillChange.send()
        item.addToDB()
    }
    
    func delete(_ item: MFBudgetDTO) {
        self.objectWillChange.send()
        item.deleteFromDB()
    }
    
    func update(_ item: MFBudgetDTO, _ amount: Int, _ date: Date) {
        self.objectWillChange.send()
        item.update(amount, date)
    }
    
    func duplicate(_ item: MFBudgetDTO) {
        self.objectWillChange.send()
        let a = MFBudgetDTO()
        a.amount = item.amount
        a.addToDB()
        for b in item.budgetItem {
            let c = MFBudgetItemDTO()
            c.amount = b.amount
            c.name = b.name
            c.addToDB()
            a.append(c)
        }
    }
}
