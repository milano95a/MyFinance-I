//
//  BudgetBrain.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import Foundation
import RealmSwift

class MFBudgetViewModel: ObservableObject {
    @Published var items: Results<MFBudgetDTO>
    
    init() {
        items = MFBudgetDTO.fetchRequest(.all)
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
}
