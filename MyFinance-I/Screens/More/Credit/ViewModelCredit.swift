import Foundation
import RealmSwift

class ViewModelCredit: ObservableObject {
    @Published var credits: Results<Credit>
    
    init() {
        credits = Credit.fetchRequest(.all)
    }
    
    func save(_ credit: Credit) {
        self.objectWillChange.send()
        credit.addToDB()
    }
    
    func delete(_ credit: Credit) {
        self.objectWillChange.send()
        credit.deleteFromDB()
    }
    
    func update(_ credit: Credit, borrower: String, amount: Int, purpose: String, date: Date) {
        self.objectWillChange.send()
        credit.update(credit, borrower: borrower, amount: amount, purpose: purpose, date: date)
    }
    
    func paid(_ credit: Credit) {
        self.objectWillChange.send()
        credit.paid()
    }
}
