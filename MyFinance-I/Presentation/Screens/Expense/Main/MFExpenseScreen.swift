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
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(vm.pagableExpenses.indices, id: \.self) { index in
                        let expense = vm.pagableExpenses[index]
                        ExpenseListItemView(expense: expense,
                                            lastPurchase: MFDefaultExpenseManager.shared.getPrevExpense(with: expense),
                                            showDate: expense.showDate,
                                            showDailyTotal: expense.showDailyTotal,
                                            showWeeklyTotal: expense.showWeeklyTotal,
                                            showMonthlyTotal: expense.showMonthlyTotal,
                                            showYearlyTotal: expense.showYearlyTotal,
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
                        .onAppear {
                            if vm.pagableExpenses.last?.id == expense.id {
                                vm.loadMore()
                            }
                        }
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
                MFFloatingButton {
                    selectedExpenseId = nil
                    showAddExpensePopup = true
                }
                ChildView()
            }
            .navigationTitle("Expenses")
            .toolbar { MFToolbar { showSettingsPopup = true } }
            .searchable(text: $vm.searchText)
            .textInputAutocapitalization(.never)
            .popover(isPresented: $showSettingsPopup) {
                SettingExpenseScreen(showYearlyTotal: vm.selectedPreferenceShowYearlyTotal,
                                     showMonthlyTotal: vm.selectedPreferenceShowMonthlyTotal,
                                     showWeeklyTotal: vm.selectedPreferenceShowWeeklyTotal,
                                     showDailyTotal: vm.selectedPreferenceShowDailyTotal,
                                     showExpense: vm.selectedPreferenceShowExpenses,
                                     selectedUnit: vm.selectedUnitOfCounting,
                                     onChangeYearlyTotal: vm.setPreferenceYearlyTotal,
                                     onChangeMonthlyTotal: vm.setPreferenceMonthlyTotal,
                                     onChangeWeeklyTotal: vm.setPreferenceWeeklyTotal,
                                     onChangeDailyTotal: vm.setPreferenceDailyTotal,
                                     onChangeExpense: vm.setPreferenceExpense, 
                                     onChangeUnit: vm.setPreferencUnit)
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

struct ChildView : View {
    @EnvironmentObject var vm: MFExpenseViewModel
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        Text("")
            .onChange(of: isSearching) { newValue in
                if !newValue {
                    vm.reset()
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
