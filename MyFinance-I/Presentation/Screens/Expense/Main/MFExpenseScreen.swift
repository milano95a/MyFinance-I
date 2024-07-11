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
    @State private var selectedExpenseId: ObjectId?
    @State private var showSettingsPopup = false
    @State private var searchText = ""
    @State private var showDeleteAlert = false

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
                SettingExpenseScreen(showYearlyTotal: vm.showYearlyTotal,
                                     showMonthlyTotal: vm.showMonthlyTotal,
                                     showWeeklyTotal: vm.showWeeklyTotal,
                                     showDailyTotal: vm.showDailyTotal,
                                     showExpense: vm.showExpense,
                                     onChangeYearlyTotal: vm.setPreferenceYearlyTotal,
                                     onChangeMonthlyTotal: vm.setPreferenceMonthlyTotal,
                                     onChangeWeeklyTotal: vm.setPreferenceWeeklyTotal,
                                     onChangeDailyTotal: vm.setPreferenceDailyTotal,
                                     onChangeExpense: vm.setPreferenceExpense)
            }
            .alert("Delete?", isPresented: $showDeleteAlert, presenting: selectedExpenseId, actions: { expense in
                Button("Delete", action: {
                    vm.delete(selectedExpenseId)
                })
                Button("Cancel", role: .cancel, action: { })
            })
        }
    }
}

extension MFExpenseScreen {
    @ViewBuilder
    var listOfExpenses: some View {
        List(vm.expenses) { expense in
            ExpenseListItemView(
                expense: expense,
                displayDate: expense.showDate,
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
                    selectedExpenseId = expense.id
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
