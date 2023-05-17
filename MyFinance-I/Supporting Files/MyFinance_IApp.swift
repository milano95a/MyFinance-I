
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
        }
    }
}
