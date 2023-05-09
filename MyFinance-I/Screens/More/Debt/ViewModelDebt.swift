import Foundation
import RealmSwift

class ViewModelDebt: ObservableObject {
    @Published var debts: Results<Debt>
    
    init() {
        debts = Debt.fetchRequest(.all)
    }
    
    func save(_ debt: Debt) {
        self.objectWillChange.send()
        debt.addToDB()
    }
    
    func delete(_ debt: Debt) {
        self.objectWillChange.send()
        debt.deleteFromDB()
    }
    
    func update(_ debt: Debt, creditor: String, amount: Int, purpose: String, date: Date) {
        self.objectWillChange.send()
        debt.update(debt, creditor: creditor, amount: amount, purpose: purpose, date: date)
    }
    
    func paid(_ debt: Debt) {
        self.objectWillChange.send()
        debt.paid()
    }

}
