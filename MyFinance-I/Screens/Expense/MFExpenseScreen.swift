//
//  MFExpenseViewModel.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 05/04/23.
//

import SwiftUI
import RealmSwift

struct MFExpenseScreen: View {

    @EnvironmentObject var vm: MFExpenseViewModel
    @State private var showAddExpensePopup = false
    @State private var showEditExpensePopup = false
    @State private var selectedExpenseId: ObjectId?
    @State private var showSettingsPopup = false
    @State private var searchText = ""
    @State private var showDeleteAlert = false
    @State private var selectedExpense: UIExpense?
    private let creationDate = Date()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                listOfExpenses
                MFFloatingButton {
                    selectedExpenseId = nil
                    showAddExpensePopup = true
                }
            }
            .navigationTitle("Expenses")
            .toolbar { MFToolbar { showSettingsPopup = true } }
            .searchable(text: $searchText).onChange(of: searchText) { newValue in
                vm.searchExpenses(with: searchText)
            }
            .textInputAutocapitalization(.never)
            .popover(isPresented: $showSettingsPopup) {
                SettingExpenseScreen()
            }
            .alert("Delete?", isPresented: $showDeleteAlert, presenting: selectedExpense, actions: { expense in
                Button("Delete", action: {
                    vm.delete(expense)
                })
                Button("Cancel", role: .cancel, action: {
                    
                })

            })
            .onAppear {
                let interval = Date().timeIntervalSince(creationDate)
                print("ExpenseScreen \(interval)")
            }
        }
    }
}

extension MFExpenseScreen {

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
                    selectedExpense = expense
                    showDeleteAlert = true
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
                EditorExpenseScreen(expense: vm.findById(id))
            } else {
                EditorExpenseScreen()
            }
        }
    }
}


















































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MFExpenseScreen()
            .environmentObject(MFExpenseViewModel())
    }
}
