
import SwiftUI
import RealmSwift

@main
struct MyFinance_IApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            InitialTabScreen()
                .environmentObject(ManagerExpense.shared)
                .environmentObject(InflationManager())
                .environmentObject(SavingsManager())
        }
    }
}
