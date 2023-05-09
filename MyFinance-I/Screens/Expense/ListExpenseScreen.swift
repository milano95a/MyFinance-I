
import SwiftUI
import RealmSwift

struct ListExpenseScreen: View {
    private let creationDate = Date()
    
    @ObservedObject var vm: ManagerExpense
    
    @State private var showAddExpensePopup = false
    @State private var showEditExpensePopup = false
    @State private var selectedExpenseId: ObjectId?
    @State private var showSettingsPopup = false
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                listOfExpenses
                addButton
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showSettingsPopup = true
                    }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
            .searchable(text: $searchText).onChange(of: searchText) { newValue in
                vm.searchExpenses(with: searchText)
            }
            .textInputAutocapitalization(.never)
            .popover(isPresented: $showSettingsPopup) {
                SettingExpenseScreen(vm: vm)
            }.onAppear {
                let interval = Date().timeIntervalSince(creationDate)
                print("ExpenseScreen \(interval)")
            }
        }
    }
}

extension ListExpenseScreen {
    @ViewBuilder
    var listOfExpenses: some View {
        List(vm.getExpenses()) { expense in
            ExpenseListItemView(
                expense: expense,
                displayDate: !expense.isSameDayAsPrevious,
                shouldShowDailyTotal: expense.showDailyTotal,
                shouldShowWeeklyTotal: expense.showWeeklyTotal,
                shouldShowMonthlyTotal: expense.showMonthlyTotal,
                shouldShowYearlyTotal: expense.showYearlyTotal,
                dailyTotal: expense.dailyTotal,
                weeklyTotal: expense.weeklyTotal,
                monthlyTotal: expense.monthlyTotal,
                yearlyTotal: expense.yearlyTotal,
                showExpense: expense.showExpense)
            .swipeActions {
                Button("Delete") {
                    vm.delete(expense)
                }.tint(.red)
                Button("Edit") {
                    selectedExpenseId = expense.id
                    showAddExpensePopup = true
                }.tint(.blue)
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .popover(isPresented: $showAddExpensePopup) { [selectedExpenseId] in
            if let id = selectedExpenseId { 
                EditorExpenseScreen(vm: vm, expense: vm.findById(id))
            } else {
                EditorExpenseScreen(vm: vm)
            }
        }
    }
    
    var addButton: some View {
        ZStack {
            Circle()
                .frame(width: 64)
                .foregroundColor(.addButtonColor)
                .padding()
                .onTapGesture {
                    selectedExpenseId = nil
                    showAddExpensePopup = true
                }
            Image(systemName: "plus")
                .foregroundColor(.white)
        }
    }
}


















































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListExpenseScreen(vm: ManagerExpense.shared)
    }
}
