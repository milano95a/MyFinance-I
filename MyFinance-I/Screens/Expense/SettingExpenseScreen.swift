//
//  SettingExpenseScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 11/04/23.
//

import SwiftUI

struct SettingExpenseScreen: View {
    
    @EnvironmentObject var manager: ManagerExpense
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
                            manager.setPreferenceYearlyTotal(newValue)
                        })
                    Toggle("Monthly Totals", isOn: $showMonthlyTotal)
                        .onChange(of: showMonthlyTotal, perform: {newValue in
                            manager.setPreferenceMonthlyTotal(newValue)
                        })
                    Toggle("Weekly Totals", isOn: $showWeeklyTotal)
                        .onChange(of: showWeeklyTotal, perform: {newValue in
                            manager.setPreferenceWeeklyTotal(newValue)
                        })
                    Toggle("Daily Totals", isOn: $showDailyTotal)
                        .onChange(of: showDailyTotal, perform: {newValue in
                            manager.setPreferenceDailyTotal(newValue)
                        })
                    Toggle("Expense", isOn: $showExpense)
                        .onChange(of: showExpense, perform: {newValue in
                            manager.setPreferenceExpense(newValue)
                        })

                }
                Button("Import Old Expenses", action: {
                    showImportJsonPopup = true
                })
                Button("Export", action: {
                    if let url = manager.exportData() {
                        share(items: [url])
                    }
                })
            }
            .navigationTitle("Settings")
            .jsonFileImporter([OldExpense].self, isPresented: $showImportJsonPopup) { oldExpenses in
                manager.deleteAll()
                manager.add(oldExpenenses: oldExpenses)
                manager.calculateTotals()
            }
            .onAppear {
                showYearlyTotal = manager.showYearlyTotal
                showMonthlyTotal = manager.showMonthlyTotal
                showWeeklyTotal = manager.showWeeklyTotal
                showDailyTotal = manager.showDailyTotal
                showExpense = manager.showExpense
            }
        }
    }
}

struct ExpenseSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingExpenseScreen()
    }
}
