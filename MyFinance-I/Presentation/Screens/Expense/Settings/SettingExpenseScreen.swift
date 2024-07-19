//
//  SettingExpenseScreen.swift
//  MyFinance-I
//
//  Created by Workspace (Abdurakhmon Jamoliddinov) on 11/04/23.
//

import SwiftUI

struct SettingExpenseScreen: View {

    @State var showYearlyTotal = false
    @State var showMonthlyTotal = false
    @State var showWeeklyTotal = false
    @State var showDailyTotal = false
    @State var showExpense = false
    @State var selectedUnit: MFUnit = .som
    
    var onChangeYearlyTotal: (Bool) -> Void
    var onChangeMonthlyTotal: (Bool) -> Void
    var onChangeWeeklyTotal: (Bool) -> Void
    var onChangeDailyTotal: (Bool) -> Void
    var onChangeExpense: (Bool) -> Void
    var onChangeUnit: (MFUnit) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Display Fields") {
                    Toggle("Yearly Totals", isOn: $showYearlyTotal)
                        .onChange(of: showYearlyTotal, perform: {newValue in
                            onChangeYearlyTotal(newValue)
                        })
                    Toggle("Monthly Totals", isOn: $showMonthlyTotal)
                        .onChange(of: showMonthlyTotal, perform: {newValue in
                            onChangeMonthlyTotal(newValue)
                        })
                    Toggle("Weekly Totals", isOn: $showWeeklyTotal)
                        .onChange(of: showWeeklyTotal, perform: {newValue in
                            onChangeWeeklyTotal(newValue)
                        })
                    Toggle("Daily Totals", isOn: $showDailyTotal)
                        .onChange(of: showDailyTotal, perform: {newValue in
                            onChangeDailyTotal(newValue)
                        })
                    Toggle("Expense", isOn: $showExpense)
                        .onChange(of: showExpense, perform: {newValue in
                            onChangeExpense(newValue)
                        })
                }
                
                Section("Display Unit") {
                    List {
                        Picker("Unit", selection: $selectedUnit) {
                            ForEach(MFUnit.allCases) { unit in
                                Text(unit.rawValue)
                            }
                        }
                    }
                }.onChange(of: selectedUnit, perform: { newValue in
                    onChangeUnit(newValue)
                })
            }
            .navigationTitle("Settings")
        }
    }
}













































struct ExpenseSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingExpenseScreen(onChangeYearlyTotal: { _ in }, onChangeMonthlyTotal: { _ in }, onChangeWeeklyTotal: { _ in }, onChangeDailyTotal: { _ in }, onChangeExpense: { _ in }, onChangeUnit: { _ in })
    }
}
