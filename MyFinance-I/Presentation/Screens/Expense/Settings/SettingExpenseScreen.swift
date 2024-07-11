//
//  SettingExpenseScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 11/04/23.
//

import SwiftUI

struct SettingExpenseScreen: View {
    
//    @EnvironmentObject var manager: MFExpenseViewModel
//    @State var showImportJsonPopup = false
    @State var showYearlyTotal = false
    @State var showMonthlyTotal = false
    @State var showWeeklyTotal = false
    @State var showDailyTotal = false
    @State var showExpense = false
    
    var onChangeYearlyTotal: (Bool) -> Void
    var onChangeMonthlyTotal: (Bool) -> Void
    var onChangeWeeklyTotal: (Bool) -> Void
    var onChangeDailyTotal: (Bool) -> Void
    var onChangeExpense: (Bool) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Show Fields") {
                    Toggle("Yearly Totals", isOn: $showYearlyTotal)
                        .onChange(of: showYearlyTotal, perform: {newValue in
                            onChangeYearlyTotal(newValue)
//                            manager.setPreferenceYearlyTotal(newValue)
                        })
                    Toggle("Monthly Totals", isOn: $showMonthlyTotal)
                        .onChange(of: showMonthlyTotal, perform: {newValue in
                            onChangeMonthlyTotal(newValue)
//                            manager.setPreferenceMonthlyTotal(newValue)
                        })
                    Toggle("Weekly Totals", isOn: $showWeeklyTotal)
                        .onChange(of: showWeeklyTotal, perform: {newValue in
                            onChangeWeeklyTotal(newValue)
//                            manager.setPreferenceWeeklyTotal(newValue)
                        })
                    Toggle("Daily Totals", isOn: $showDailyTotal)
                        .onChange(of: showDailyTotal, perform: {newValue in
                            onChangeDailyTotal(newValue)
//                            manager.setPreferenceDailyTotal(newValue)
                        })
                    Toggle("Expense", isOn: $showExpense)
                        .onChange(of: showExpense, perform: {newValue in
                            onChangeExpense(newValue)
//                            manager.setPreferenceExpense(newValue)
                        })

                }
            }
            .navigationTitle("Settings")
//            .onAppear {
//                showYearlyTotal = manager.showYearlyTotal
//                showMonthlyTotal = manager.showMonthlyTotal
//                showWeeklyTotal = manager.showWeeklyTotal
//                showDailyTotal = manager.showDailyTotal
//                showExpense = manager.showExpense
//            }
        }
    }
}

struct ExpenseSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingExpenseScreen(onChangeYearlyTotal: { _ in }, onChangeMonthlyTotal: { _ in }, onChangeWeeklyTotal: { _ in }, onChangeDailyTotal: { _ in }, onChangeExpense: { _ in })
    }
}
