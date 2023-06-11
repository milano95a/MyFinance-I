
import SwiftUI
import RealmSwift

@main
struct MyFinance_IApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            InitialTabScreen()
                .environmentObject(ManagerExpense())
                .environmentObject(CreditManager())
                .environmentObject(DebtManager())
                .environmentObject(InflationManager())
                .environmentObject(ExpenseChartManager())
                .environmentObject(SavingsManager())
                .environmentObject(ExportManager())
                .environmentObject(ImportManager())
                .environmentObject(ManagerCostOfThingsIn30Years(ManagerExpense()))
        }
    }
}
