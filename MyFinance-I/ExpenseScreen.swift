
import SwiftUI
import RealmSwift

struct ExpenseScreen: View {
    @ObservedObject var vm: ExpenseViewModel
    
    @State private var showImportJsonPopup = false
    @State private var showAddExpensePopup = false
    @State private var selectedExpense: Expense?
    @State private var searchText = ""

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
                        showImportJsonPopup = true
                    }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
            .jsonFileImporter([OldExpense].self, isPresented: $showImportJsonPopup) { oldExpenses in
                vm.deleteAll()
                vm.add(oldExpenenses: oldExpenses)
                vm.calculateTotals()
            }
            .searchable(text: $searchText).onChange(of: searchText) { newValue in
                vm.searchExpenses(with: searchText)
            }
        }
    }
}

extension ExpenseScreen {
    
    @ViewBuilder
    var listOfExpenses: some View {
        List(vm.expenses.freeze().indices, id: \.self) { index in
            ExpenseListItemView(
                expense: vm.expenses[index],
                displayDate: index == 0 ? true : !vm.isSameDay(index, index-1),
                displayWeek: index == 0 ? true : !vm.isSamedWeek(index, index-1),
                displayMonth: index == 0 ? true : !vm.isSameMonth(index, index-1),
                displayYear: index == 0 ? true : !vm.isSameYear(index, index-1),
                dailyTotal: vm.dailyTotalFor(vm.expenses[index]),
                weeklyTotal: vm.weeklyTotalFor(vm.expenses[index]),
                monthlyTotal: vm.monthlyTotalFor(vm.expenses[index]),
                yearlyTotal: vm.yearlyTotalFor(vm.expenses[index])
            )
            .swipeActions {
                Button("Delete") {
                    vm.delete(vm.expenses[index])
                }.tint(.red)
                Button("Edit") {
                    selectedExpense = vm.expenses[index]
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
        ZStack {
            Circle()
                .frame(width: 48)
                .foregroundColor(.blue)
                .padding()
                .onTapGesture {
                    showAddExpensePopup = true
                }
            Image(systemName: "plus")
                .foregroundColor(.white)
        }
    }
}


















































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseScreen(vm: ExpenseViewModel.shared)
    }
}
