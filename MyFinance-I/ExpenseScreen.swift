
import SwiftUI
import RealmSwift

struct ExpenseScreen: View {
    @ObservedObject var vm: ExpenseViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            listOfExpenses
            addButton
        }
    }
    
    @ViewBuilder
    var listOfExpenses: some View {
//        if vm.expenses == nil {
//            EmptyView()
//        } else {
        List(vm.expenses.freeze()) { expense in
                ExpenseListItemView(expense: expense)
                .swipeActions {
                    Button("Delete") {
                        vm.delete(expense)
                    }.tint(.red)
                    Button("Edit") {
                        
                    }.tint(.blue)
                }
            }
//        }
    }
    
    var addButton: some View {
        Button("Add") {
            vm.add(name: "saxarniy pudra", price: 4000, quantity: 1, date: Date())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseScreen(vm: ExpenseViewModel())
    }
}
