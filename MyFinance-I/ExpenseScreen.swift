
import SwiftUI
import RealmSwift

struct ExpenseScreen: View {
    @ObservedObject var vm: ExpenseViewModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                listOfExpenses
                addButton
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        vm.importDataFromJson()
                    }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
        }
    }
    
    @State private var showAddExpensePopup = false
    @State private var selectedExpense: Expense?
    
    @ViewBuilder
    var listOfExpenses: some View {
        List(vm.expenses.freeze()) { expense in
            ExpenseListItemView(expense: expense)
                .swipeActions {
                    Button("Delete") {
                        vm.delete(expense)
                    }.tint(.red)
                    Button("Edit") {
                        selectedExpense = expense
                    }.tint(.blue)
                }
        }
        .popover(isPresented: $showAddExpensePopup) {
            ExpenseEditorView(vm: vm)
        }
        .popover(item: $selectedExpense) { expense in
            ExpenseEditorView(vm: vm, expense: expense)
        }
    }
    
    var addButton: some View {
        Button("Add") {
            showAddExpensePopup = true
        }
    }
}























































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseScreen(vm: ExpenseViewModel())
    }
}
