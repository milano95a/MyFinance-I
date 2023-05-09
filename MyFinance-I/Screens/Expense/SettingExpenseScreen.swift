//
//  SettingExpenseScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 11/04/23.
//

import SwiftUI

struct SettingExpenseScreen: View {
    @ObservedObject var vm: ManagerExpense
    
    @State private var showImportJsonPopup = false
    @State private var showYearlyTotal = false
    @State private var showMonthlyTotal = false
    @State private var showWeeklyTotal = false
    @State private var showDailyTotal = false
    @State private var showExpense = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Show Fields") {
                    Toggle("Yearly Totals", isOn: $showYearlyTotal)
                        .onChange(of: showYearlyTotal, perform: {newValue in
                            vm.setPreferenceYearlyTotal(newValue)
                        })
                    Toggle("Monthly Totals", isOn: $showMonthlyTotal)
                        .onChange(of: showMonthlyTotal, perform: {newValue in
                            vm.setPreferenceMonthlyTotal(newValue)
                        })
                    Toggle("Weekly Totals", isOn: $showWeeklyTotal)
                        .onChange(of: showWeeklyTotal, perform: {newValue in
                            vm.setPreferenceWeeklyTotal(newValue)
                        })
                    Toggle("Daily Totals", isOn: $showDailyTotal)
                        .onChange(of: showDailyTotal, perform: {newValue in
                            vm.setPreferenceDailyTotal(newValue)
                        })
                    Toggle("Expense", isOn: $showExpense)
                        .onChange(of: showExpense, perform: {newValue in
                            vm.setPreferenceExpense(newValue)
                        })

                }
                Button("Import Old Expenses", action: {
                    showImportJsonPopup = true
                })
                Button("Export", action: {
                    if let url = vm.exportData() {
                        share(items: [url])
                    }
                })
            }
            .navigationTitle("Settings")
            .jsonFileImporter([OldExpense].self, isPresented: $showImportJsonPopup) { oldExpenses in
                vm.deleteAll()
                vm.add(oldExpenenses: oldExpenses)
                vm.calculateTotals()
            }
            .onAppear {
                showYearlyTotal = vm.showYearlyTotal
                showMonthlyTotal = vm.showMonthlyTotal
                showWeeklyTotal = vm.showWeeklyTotal
                showDailyTotal = vm.showDailyTotal
                showExpense = vm.showExpense
            }
        }
    }
}

struct ExpenseSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingExpenseScreen(vm: ManagerExpense.shared)
    }
}
