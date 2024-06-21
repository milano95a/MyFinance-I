//
//  MFBudgetViewModel.swift
//  MyFinance-I
//
//  Created by Jamoliddinov Abduraxmon on 03/06/24.
//

import Foundation
import RealmSwift
import Combine

class MFBudgetViewModel: ObservableObject {

    @Published var parent: MFBudgetDTO?
    @Published var selectedItem: MFBudgetItemDTO?
    @Published var name: String = ""
    @Published var amount: String = ""
    @Published var percentage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Intent(s)
    func delete(_ item: MFBudgetItemDTO) {
        self.objectWillChange.send()
        item.deleteFromDB()
    }
        
    func save() {
        if selectedItem != nil  {
            update()
        } else {
            create()
        }
    }
    
    func clear() {
        selectedItem = nil
        name = ""
        amount = ""
        percentage = ""
    }
    
    // MARK: Public API(s)
    func percentage(budgetAmount: Int) -> String {
        if let parent {
            return "\((Double(budgetAmount) / Double(parent.amount) * 100).rounded(toPlaces: 2))%"
        } else {
            return "n/a"
        }
    }
    
    func load() {
        if let parent {
            self.parent = nil
            self.parent = Realm.shared().objects(MFBudgetDTO.self).where { $0.id == parent.id }.first
        }
    }
    
    func budget() -> Int {
        return parent?.amount ?? 0
    }
    
    func allocated() -> Int {
        return parent?.budgetItem.reduce(0, { $0 + $1.amount }) ?? 0
    }
    
    func unbudgeted() -> Int {
        return budget() - allocated()
    }
    
    // MARK: Helper(s)
    init(parent: MFBudgetDTO) {
        self.parent = Realm.shared().objects(MFBudgetDTO.self).where { $0.id == parent.id }.first
        
        $amount.sink { newValue in
            
        }.store(in: &cancellables)
        
        $percentage.sink { [weak self] newValue in
            guard let totalAmount = self?.parent?.amount else { return }
            guard let newValueDouble = Double(newValue) else { return }
            let percent = newValueDouble / 100
            let amount = Double(totalAmount) * percent
            self?.amount = amount.removeZerosFromEnd()
        }.store(in: &cancellables)
    }
    
    private func update() {
        if let item = selectedItem, let amount = Int(amount) {
            self.objectWillChange.send()
            item.update(name, amount)
        }
    }
    
    private func create() {
        if let amount = Int(amount) {
            self.objectWillChange.send()
            let item = MFBudgetItemDTO()
            item.name = name
            item.amount = amount
            item.addToDB()
            parent?.append(item)
        }
    }
}
