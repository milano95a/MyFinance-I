
import SwiftUI
import RealmSwift

struct ExpenseScreen: View {
    private let creationDate = Date()
    
    @ObservedObject var vm: ExpenseManager
    
    @State private var showAddExpensePopup = false
    @State private var selectedExpense: Expense?
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
            .popover(isPresented: $showSettingsPopup) {
                ExpenseSettingScreen(vm: vm)
            }.onAppear {
                let interval = Date().timeIntervalSince(creationDate)
                print(interval)
            }
        }
    }
}

extension ExpenseScreen {
    @ViewBuilder
    var listOfExpenses: some View {
        List(vm.expenses.freeze().indices, id: \.self) { index in
            if let shouldShowDailyTotal = shouldShowDailyTotal(index),
                let shouldShowWeeklyTotal = shouldShowWeeklyTotal(index),
                let shouldShowMonthlyTotal = shouldShowMonthlyTotal(index),
                let shouldShowYearlyTotal = shouldShowYearlyTotal(index) {
                ExpenseListItemView(
                    expense: vm.expenses[index],
                    displayDate: index == 0 ? true : !vm.isSameDay(index, index-1),

                    shouldShowDailyTotal: shouldShowDailyTotal,
                    shouldShowWeeklyTotal: shouldShowWeeklyTotal,
                    shouldShowMonthlyTotal: shouldShowMonthlyTotal,
                    shouldShowYearlyTotal: shouldShowYearlyTotal,

                    dailyTotal: vm.dailyTotalFor(vm.expenses[index]),
                    weeklyTotal: vm.weeklyTotalFor(vm.expenses[index]),
                    monthlyTotal: vm.monthlyTotalFor(vm.expenses[index]),
                    yearlyTotal: vm.yearlyTotalFor(vm.expenses[index]),

                    showExpense: vm.showExpense
                )
                .swipeActions {
                    Button("Delete") {
                        vm.delete(vm.expenses[index])
                    }.tint(.red)
                    Button("Edit") {
                        selectedExpense = vm.expenses[index]
                    }.tint(.blue)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            } else {
                EmptyView()
            }
            
//            if shouldShowDailyTotal(index) || shouldShowWeeklyTotal(index) || shouldShowMonthlyTotal(index) || shouldShowYearlyTotal(index) || vm.showExpense {
//                ExpenseListItemView(
//                    expense: vm.expenses[index],
//                    displayDate: index == 0 ? true : !vm.isSameDay(index, index-1),
//
//                    shouldShowDailyTotal: shouldShowDailyTotal(index),
//                    shouldShowWeeklyTotal: shouldShowWeeklyTotal(index),
//                    shouldShowMonthlyTotal: shouldShowMonthlyTotal(index),
//                    shouldShowYearlyTotal: shouldShowYearlyTotal(index),
//
//                    dailyTotal: vm.dailyTotalFor(vm.expenses[index]),
//                    weeklyTotal: vm.weeklyTotalFor(vm.expenses[index]),
//                    monthlyTotal: vm.monthlyTotalFor(vm.expenses[index]),
//                    yearlyTotal: vm.yearlyTotalFor(vm.expenses[index]),
//
//                    showExpense: vm.showExpense
//                )
//                .swipeActions {
//                    Button("Delete") {
//                        vm.delete(vm.expenses[index])
//                    }.tint(.red)
//                    Button("Edit") {
//                        selectedExpense = vm.expenses[index]
//                    }.tint(.blue)
//                }
//                .listRowSeparator(.hidden)
//                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
//            } else {
//                EmptyView()
//            }
        }
        .popover(isPresented: $showAddExpensePopup) {
            ExpenseEditorScreen(vm: vm)
        }
        .popover(item: $selectedExpense) { expense in
            ExpenseEditorScreen(vm: vm, expense: expense)
        }
    }
    
    private func shouldShowDailyTotal(_ index: Int) -> Bool {
        var value = false
        
//        let result = ContinuousClock().measure {
            if vm.showDailyTotal {
                if index == 0 {
                    value = true
                } else if vm.isSameDay(index, index-1) {
                    value = false
                } else {
                    value = true
                }
            } else {
                value = false
            }
//        }
//        print(result)
        
        return value
        
//        if vm.showDailyTotal {
//            if index == 0 {
//                return true
//            } else if vm.isSameDay(index, index-1) {
//                return false
//            } else {
//                return true
//            }
//        } else {
//            return false
//        }
    }
    
    private func shouldShowWeeklyTotal(_ index: Int) -> Bool {
//        let start = CFAbsoluteTimeGetCurrent()
//        defer {
//            let diff = CFAbsoluteTimeGetCurrent() - start
//            print("shouldShowWeeklyTotal took \(diff) seconds")
//        }
        
        if vm.showWeeklyTotal {
            if index == 0 {
                return true
            } else if vm.isSamedWeek(index, index-1) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    private func shouldShowMonthlyTotal(_ index: Int) -> Bool {
//        let start = CFAbsoluteTimeGetCurrent()
//        defer {
//            let diff = CFAbsoluteTimeGetCurrent() - start
//            print("shouldShowMonthlyTotal took \(diff) seconds")
//        }
        
        if vm.showMonthlyTotal {
            if index == 0 {
                return true
            } else if vm.isSameMonth(index, index-1) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    private func shouldShowYearlyTotal(_ index: Int) -> Bool {
//        let start = CFAbsoluteTimeGetCurrent()
//        defer {
//            let diff = CFAbsoluteTimeGetCurrent() - start
//            print("shouldShowYearlyTotal took \(diff) seconds")
//        }
        
        if vm.showYearlyTotal {
            if index == 0 {
                return true
            } else if vm.isSameYear(index, index-1) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    var addButton: some View {
        ZStack {
            Circle()
                .frame(width: 48)
                .foregroundColor(.addButtonColor)
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
        ExpenseScreen(vm: ExpenseManager.shared)
    }
}
